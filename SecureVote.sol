pragma solidity ^0.6.0;

contract Survey {
    enum Choice {
        none, a, b, c
    }

          address organizer;

                                                                            
    mapping(address   => Choice  ) current_votes;

                                                                                          
    uint32              a_count;
    uint32              b_count;
    uint32              c_count;

                                                                       
    uint min_votes;

                            
    uint vote_count;

                                                                                 
    uint packed_results;

    constructor(uint _min_votes) public {
        require(_min_votes > 0);
        organizer = me;
        min_votes = _min_votes;
    }

                               

    function vote(Choice    votum) public {
        require(      (votum != Choice.none && current_votes[me] == Choice.none     ));
        require(!is_result_published());
        current_votes[me] = votum;
        vote_count += 1;
        a_count = a_count +       (votum == Choice.a ? 1 : 0           );
        b_count = b_count +       (votum == Choice.b ? 1 : 0           );
        c_count = c_count +       (votum == Choice.c ? 1 : 0           );
    }

    function publish_results() public {
        require(me == organizer);
        require(min_votes_reached());
        require(!is_result_published());
        packed_results =       ((uint192(     (c_count)) << 128) | (uint192(     (b_count)) << 64) | uint192(     (a_count))     );
    }

              

    function get_result_for(Choice option) public view returns(uint64) {
        require(is_result_published());
        uint64 res;
        if (option != Choice.none) {
            res = uint64(packed_results >> 64*(uint(option)-1));
        }
        return res;
    }

    function get_winning_choice() public view returns(Choice) {
        Choice c = Choice.none;
        uint votes = 0;
        for (uint i = uint(Choice.a); i <= uint(Choice.c); ++i) {
            uint res = get_result_for(Choice(i));
            if (res > votes) {
                c = Choice(i);
                votes = res;
            }
        }
        return c;
    }

                               
    function check_if_agree_with_majority() public view returns(bool   ) {
        Choice c = get_winning_choice();
        return c == current_votes[me];
    }

    function min_votes_reached() public view returns(bool) {
        return vote_count >= min_votes;
    }

    function is_result_published() public view returns(bool) {
        return packed_results != 0;
    }
 address private me = msg.sender;}
