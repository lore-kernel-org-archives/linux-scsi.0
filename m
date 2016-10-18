From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: iscsi_trx going into D state
Date: Mon, 17 Oct 2016 22:42:14 -0600
Message-ID: <CAANLjFpx1MRNiu2388pY+U0O5z9gw+OJBtpOof47Lb_DxaJSBQ@mail.gmail.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <880e374c-cf8b-f276-e930-57b09fe1a686@suse.com> <CAANLjFobXiBO2tXxTBB-8BQjM8FC0wmxdxQvEd6Rp=1LZkrvpA@mail.gmail.com>
 <CAANLjFoh+C8QE=qcPKqUUG3SnH2EMmS7DWZ5D4AD7yWMxoK0Zw@mail.gmail.com> <4fc72e32-26fb-96bd-8a0d-814eef712b43@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4fc72e32-26fb-96bd-8a0d-814eef712b43-IBi9RG/b67k@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Lingshan <lszhu-IBi9RG/b67k@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Sorry I forget that Android has an aversion to plain text emails.

If we can provide any information to help, let us know. We are willing
to patch in more debug statements or whatever you think might help.
Today has been a difficult day. Thanks for looking into it, I tried
looking at it, but it is way over my head.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Mon, Oct 17, 2016 at 9:06 PM, Zhu Lingshan <lszhu-IBi9RG/b67k@public.gmane.org> wrote:
> Hi Robert,
>
> I think the reason why you can not logout the targets is that iscsi_np in=
 D
> status. I think the patches fixed something, but it seems to be more than
> one code path can trigger these similar issues. as you can see, there are
> several call stacks, I am still working on it. Actually in my environment=
 I
> see there is another call stack not listed in your mail....
>
> Thanks,
> BR
> Zhu Lingshan
>
>
> On 10/18/2016 03:11 AM, Robert LeBlanc wrote:
>>
>> Sorry hit send too soon.
>>
>> In addition, on the client we see:
>> # ps -aux | grep D | grep kworker
>> root      5583  0.0  0.0      0     0 ?        D    11:55   0:03
>> [kworker/11:0]
>> root      7721  0.1  0.0      0     0 ?        D    12:00   0:04
>> [kworker/4:25]
>> root     10877  0.0  0.0      0     0 ?        D    09:27   0:00
>> [kworker/22:1]
>> root     11246  0.0  0.0      0     0 ?        D    10:28   0:00
>> [kworker/30:2]
>> root     14034  0.0  0.0      0     0 ?        D    12:20   0:02
>> [kworker/19:15]
>> root     14048  0.0  0.0      0     0 ?        D    12:20   0:00
>> [kworker/16:0]
>> root     15871  0.0  0.0      0     0 ?        D    12:25   0:00
>> [kworker/13:0]
>> root     17442  0.0  0.0      0     0 ?        D    12:28   0:00
>> [kworker/9:1]
>> root     17816  0.0  0.0      0     0 ?        D    12:30   0:00
>> [kworker/11:1]
>> root     18744  0.0  0.0      0     0 ?        D    12:32   0:00
>> [kworker/10:2]
>> root     19060  0.0  0.0      0     0 ?        D    12:32   0:00
>> [kworker/29:0]
>> root     21748  0.0  0.0      0     0 ?        D    12:40   0:00
>> [kworker/21:0]
>> root     21967  0.0  0.0      0     0 ?        D    12:40   0:00
>> [kworker/22:0]
>> root     21978  0.0  0.0      0     0 ?        D    12:40   0:00
>> [kworker/22:2]
>> root     22024  0.0  0.0      0     0 ?        D    12:40   0:00
>> [kworker/22:4]
>> root     22035  0.0  0.0      0     0 ?        D    12:40   0:00
>> [kworker/22:5]
>> root     22060  0.0  0.0      0     0 ?        D    12:40   0:00
>> [kworker/16:1]
>> root     22282  0.0  0.0      0     0 ?        D    12:41   0:00
>> [kworker/26:0]
>> root     22362  0.0  0.0      0     0 ?        D    12:42   0:00
>> [kworker/18:9]
>> root     22426  0.0  0.0      0     0 ?        D    12:42   0:00
>> [kworker/16:3]
>> root     23298  0.0  0.0      0     0 ?        D    12:43   0:00
>> [kworker/12:1]
>> root     23302  0.0  0.0      0     0 ?        D    12:43   0:00
>> [kworker/12:5]
>> root     24264  0.0  0.0      0     0 ?        D    12:46   0:00
>> [kworker/30:1]
>> root     24271  0.0  0.0      0     0 ?        D    12:46   0:00
>> [kworker/14:8]
>> root     24441  0.0  0.0      0     0 ?        D    12:47   0:00
>> [kworker/9:7]
>> root     24443  0.0  0.0      0     0 ?        D    12:47   0:00
>> [kworker/9:9]
>> root     25005  0.0  0.0      0     0 ?        D    12:48   0:00
>> [kworker/30:3]
>> root     25158  0.0  0.0      0     0 ?        D    12:49   0:00
>> [kworker/9:12]
>> root     26382  0.0  0.0      0     0 ?        D    12:52   0:00
>> [kworker/13:2]
>> root     26453  0.0  0.0      0     0 ?        D    12:52   0:00
>> [kworker/21:2]
>> root     26724  0.0  0.0      0     0 ?        D    12:53   0:00
>> [kworker/19:1]
>> root     28400  0.0  0.0      0     0 ?        D    05:20   0:00
>> [kworker/25:1]
>> root     29552  0.0  0.0      0     0 ?        D    11:40   0:00
>> [kworker/17:1]
>> root     29811  0.0  0.0      0     0 ?        D    11:40   0:00
>> [kworker/7:10]
>> root     31903  0.0  0.0      0     0 ?        D    11:43   0:00
>> [kworker/26:1]
>>
>> And all of the processes have this stack:
>> [<ffffffffa0727ed5>] iser_release_work+0x25/0x60 [ib_iser]
>> [<ffffffff8109633f>] process_one_work+0x14f/0x400
>> [<ffffffff81096bb4>] worker_thread+0x114/0x470
>> [<ffffffff8109c6f8>] kthread+0xd8/0xf0
>> [<ffffffff8172004f>] ret_from_fork+0x3f/0x70
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> We are not able to log out of the sessions in all cases. And have to
>> restart the box.
>>
>> iscsiadm -m session will show messages like:
>> iscsiadm: could not read session targetname: 5
>> iscsiadm: could not find session info for session100
>> iscsiadm: could not read session targetname: 5
>> iscsiadm: could not find session info for session101
>> iscsiadm: could not read session targetname: 5
>> iscsiadm: could not find session info for session103
>> ...
>>
>> I can't find any way to force iscsiadm to clean up these sessions
>> possibly due to tasks in D state.
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>
>>
>> On Mon, Oct 17, 2016 at 10:32 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
>> wrote:
>>>
>>> Some more info as we hit this this morning. We have volumes mirrored
>>> between two targets and we had one target on the kernel with the three
>>> patches mentioned in this thread [0][1][2] and the other was on a
>>> kernel without the patches. We decided that after a week and a half we
>>> wanted to get both targets on the same kernel so we rebooted the
>>> non-patched target. Within an hour we saw iSCSI in D state with the
>>> same stack trace so it seems that we are not hitting any of the
>>> WARN_ON lines. We are getting both iscsi_trx and iscsi_np both in D
>>> state, this time we have two iscsi_trx processes in D state. I don't
>>> know if stale sessions on the clients could be contributing to this
>>> issue (the target trying to close non-existent sessions??). This is on
>>> 4.4.23. Any more debug info we can throw at this problem to help?
>>>
>>> Thank you,
>>> Robert LeBlanc
>>>
>>> # ps aux | grep D | grep iscsi
>>> root     16525  0.0  0.0      0     0 ?        D    08:50   0:00
>>> [iscsi_np]
>>> root     16614  0.0  0.0      0     0 ?        D    08:50   0:00
>>> [iscsi_trx]
>>> root     16674  0.0  0.0      0     0 ?        D    08:50   0:00
>>> [iscsi_trx]
>>>
>>> # for i in 16525 16614 16674; do echo $i; cat /proc/$i/stack; done
>>> 16525
>>> [<ffffffff814f0d5f>] iscsit_stop_session+0x19f/0x1d0
>>> [<ffffffff814e2516>] iscsi_check_for_session_reinstatement+0x1e6/0x270
>>> [<ffffffff814e4ed0>] iscsi_target_check_for_existing_instances+0x30/0x4=
0
>>> [<ffffffff814e5020>] iscsi_target_do_login+0x140/0x640
>>> [<ffffffff814e63bc>] iscsi_target_start_negotiation+0x1c/0xb0
>>> [<ffffffff814e410b>] iscsi_target_login_thread+0xa9b/0xfc0
>>> [<ffffffff8109c748>] kthread+0xd8/0xf0
>>> [<ffffffff8172018f>] ret_from_fork+0x3f/0x70
>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>> 16614
>>> [<ffffffff814cca79>] target_wait_for_sess_cmds+0x49/0x1a0
>>> [<ffffffffa064692b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
>>> [<ffffffff814f0ef2>] iscsit_close_connection+0x162/0x870
>>> [<ffffffff814df9bf>] iscsit_take_action_for_connection_exit+0x7f/0x100
>>> [<ffffffff814f00a0>] iscsi_target_rx_thread+0x5a0/0xe80
>>> [<ffffffff8109c748>] kthread+0xd8/0xf0
>>> [<ffffffff8172018f>] ret_from_fork+0x3f/0x70
>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>> 16674
>>> [<ffffffff814cca79>] target_wait_for_sess_cmds+0x49/0x1a0
>>> [<ffffffffa064692b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
>>> [<ffffffff814f0ef2>] iscsit_close_connection+0x162/0x870
>>> [<ffffffff814df9bf>] iscsit_take_action_for_connection_exit+0x7f/0x100
>>> [<ffffffff814f00a0>] iscsi_target_rx_thread+0x5a0/0xe80
>>> [<ffffffff8109c748>] kthread+0xd8/0xf0
>>> [<ffffffff8172018f>] ret_from_fork+0x3f/0x70
>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>>
>>> [0] https://www.spinics.net/lists/target-devel/msg13463.html
>>> [1] http://marc.info/?l=3Dlinux-scsi&m=3D147282568910535&w=3D2
>>> [2] http://www.spinics.net/lists/linux-scsi/msg100221.html
>>> ----------------
>>> Robert LeBlanc
>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>
>>>
>>> On Fri, Oct 7, 2016 at 8:59 PM, Zhu Lingshan <lszhu-IBi9RG/b67k@public.gmane.org> wrote:
>>>>
>>>> Hi Robert,
>>>>
>>>> I also see this issue, but this is not the only code path can trigger
>>>> this
>>>> problem, I think you may also see iscsi_np in D status. I fixed one co=
de
>>>> path whitch still not merged to mainline. I will forward you my patch
>>>> later.
>>>> Note: my patch only fixed one code path, you may see other call statck
>>>> with
>>>> D status.
>>>>
>>>> Thanks,
>>>> BR
>>>> Zhu Lingshan
>>>>
>>>>
>>>> =E5=9C=A8 2016/10/1 1:14, Robert LeBlanc =E5=86=99=E9=81=93:
>>>>>
>>>>> We are having a reoccurring problem where iscsi_trx is going into D
>>>>> state. It seems like it is waiting for a session tear down to happen
>>>>> or something, but keeps waiting. We have to reboot these targets on
>>>>> occasion. This is running the 4.4.12 kernel and we have seen it on
>>>>> several previous 4.4.x and 4.2.x kernels. There is no message in dmes=
g
>>>>> or /var/log/messages. This seems to happen with increased frequency
>>>>> when we have a disruption in our Infiniband fabric, but can happen
>>>>> without any changes to the fabric (other than hosts rebooting).
>>>>>
>>>>> # ps aux | grep iscsi | grep D
>>>>> root      4185  0.0  0.0      0     0 ?        D    Sep29   0:00
>>>>> [iscsi_trx]
>>>>> root     18505  0.0  0.0      0     0 ?        D    Sep29   0:00
>>>>> [iscsi_np]
>>>>>
>>>>> # cat /proc/4185/stack
>>>>> [<ffffffff814cc999>] target_wait_for_sess_cmds+0x49/0x1a0
>>>>> [<ffffffffa087292b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
>>>>> [<ffffffff814f0de2>] iscsit_close_connection+0x162/0x840
>>>>> [<ffffffff814df8df>] iscsit_take_action_for_connection_exit+0x7f/0x10=
0
>>>>> [<ffffffff814effc0>] iscsi_target_rx_thread+0x5a0/0xe80
>>>>> [<ffffffff8109c6f8>] kthread+0xd8/0xf0
>>>>> [<ffffffff8172004f>] ret_from_fork+0x3f/0x70
>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>>
>>>>> # cat /proc/18505/stack
>>>>> [<ffffffff814f0c71>] iscsit_stop_session+0x1b1/0x1c0
>>>>> [<ffffffff814e2436>] iscsi_check_for_session_reinstatement+0x1e6/0x27=
0
>>>>> [<ffffffff814e4df0>]
>>>>> iscsi_target_check_for_existing_instances+0x30/0x40
>>>>> [<ffffffff814e4f40>] iscsi_target_do_login+0x140/0x640
>>>>> [<ffffffff814e62dc>] iscsi_target_start_negotiation+0x1c/0xb0
>>>>> [<ffffffff814e402b>] iscsi_target_login_thread+0xa9b/0xfc0
>>>>> [<ffffffff8109c6f8>] kthread+0xd8/0xf0
>>>>> [<ffffffff8172004f>] ret_from_fork+0x3f/0x70
>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>>
>>>>> What can we do to help get this resolved?
>>>>>
>>>>> Thanks,
>>>>>
>>>>> ----------------
>>>>> Robert LeBlanc
>>>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>>>>> in
>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
