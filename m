From: Doug Ledford <dledford@redhat.com>
Subject: Re: iscsi_trx going into D state
Date: Thu, 22 Dec 2016 14:15:43 -0500
Message-ID: <6beeb461-0391-cb29-8cf7-74f4c8feda34@redhat.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <CAANLjFobXiBO2tXxTBB-8BQjM8FC0wmxdxQvEd6Rp=1LZkrvpA@mail.gmail.com>
 <CAANLjFoh+C8QE=qcPKqUUG3SnH2EMmS7DWZ5D4AD7yWMxoK0Zw@mail.gmail.com>
 <4fc72e32-26fb-96bd-8a0d-814eef712b43@suse.com>
 <CAANLjFpx1MRNiu2388pY+U0O5z9gw+OJBtpOof47Lb_DxaJSBQ@mail.gmail.com>
 <1476774332.8490.43.camel@haakon3.risingtidesystems.com>
 <CAANLjFqXt5r=c9F75vjeK=_zLa8zCS1priLuZo=A1ZSHKZ=1Bw@mail.gmail.com>
 <1476858359.8490.97.camel@haakon3.risingtidesystems.com>
 <CAANLjFoGEi29goybqsvEg6trystEkurVz52P8SwqGUSNV1jdSw@mail.gmail.com>
 <1477780190.22703.47.camel@haakon3.risingtidesystems.com>
 <CAANLjFpkEVmO83r5YWh=hCnN=AUf9bvrrCyVJHc-=CRpc3P0vQ@mail.gmail.com>
 <CAANLjFqoHuSq2SsNZ4J2uvAQGPg0F1tpxeJuAQT1oM1hXQ0wew@mail.gmail.com>
 <CAANLjFpYT62G86w-r00+shJUyrPd68BS64y8f9OZemz_5kojzg@mail.gmail.com>
 <CAANLjFon+re7eMriFjnFfR-4SnzxR4LLSb2qcwhfkb7ODbuTwg@mail.gmail.com>
 <CAANLjFpoWruzYEDohQrAKCxp9NSGhZM3mv=x+9+L7x1+fwYN6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JNuHaxVoiQrA0fRPfcBC01PFUMi1MLFsc"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbcLVTQD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 14:16:03 -0500
In-Reply-To: <CAANLjFpoWruzYEDohQrAKCxp9NSGhZM3mv=x+9+L7x1+fwYN6w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Zhu Lingshan <lszhu@suse.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JNuHaxVoiQrA0fRPfcBC01PFUMi1MLFsc
Content-Type: multipart/mixed; boundary="o4HN48kGU9qe9oohQsJ8r0C0mErVr6tjf";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Robert LeBlanc <robert@leblancnet.us>,
 "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Zhu Lingshan <lszhu@suse.com>, linux-rdma <linux-rdma@vger.kernel.org>,
 linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
 Christoph Hellwig <hch@lst.de>
Message-ID: <6beeb461-0391-cb29-8cf7-74f4c8feda34@redhat.com>
Subject: Re: iscsi_trx going into D state
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <880e374c-cf8b-f276-e930-57b09fe1a686@suse.com>
 <CAANLjFobXiBO2tXxTBB-8BQjM8FC0wmxdxQvEd6Rp=1LZkrvpA@mail.gmail.com>
 <CAANLjFoh+C8QE=qcPKqUUG3SnH2EMmS7DWZ5D4AD7yWMxoK0Zw@mail.gmail.com>
 <4fc72e32-26fb-96bd-8a0d-814eef712b43@suse.com>
 <CAANLjFpx1MRNiu2388pY+U0O5z9gw+OJBtpOof47Lb_DxaJSBQ@mail.gmail.com>
 <1476774332.8490.43.camel@haakon3.risingtidesystems.com>
 <CAANLjFqXt5r=c9F75vjeK=_zLa8zCS1priLuZo=A1ZSHKZ=1Bw@mail.gmail.com>
 <1476858359.8490.97.camel@haakon3.risingtidesystems.com>
 <CAANLjFoGEi29goybqsvEg6trystEkurVz52P8SwqGUSNV1jdSw@mail.gmail.com>
 <1477780190.22703.47.camel@haakon3.risingtidesystems.com>
 <CAANLjFpkEVmO83r5YWh=hCnN=AUf9bvrrCyVJHc-=CRpc3P0vQ@mail.gmail.com>
 <CAANLjFqoHuSq2SsNZ4J2uvAQGPg0F1tpxeJuAQT1oM1hXQ0wew@mail.gmail.com>
 <CAANLjFpYT62G86w-r00+shJUyrPd68BS64y8f9OZemz_5kojzg@mail.gmail.com>
 <CAANLjFon+re7eMriFjnFfR-4SnzxR4LLSb2qcwhfkb7ODbuTwg@mail.gmail.com>
 <CAANLjFpoWruzYEDohQrAKCxp9NSGhZM3mv=x+9+L7x1+fwYN6w@mail.gmail.com>
In-Reply-To: <CAANLjFpoWruzYEDohQrAKCxp9NSGhZM3mv=x+9+L7x1+fwYN6w@mail.gmail.com>

--o4HN48kGU9qe9oohQsJ8r0C0mErVr6tjf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/21/2016 6:39 PM, Robert LeBlanc wrote:
> I hit a new backtrace today, hopefully it adds something.
>=20
> # cat /proc/19659/stack
> [<ffffffff815304d1>] iscsit_stop_session+0x1b1/0x1c0
> [<ffffffff81521c62>] iscsi_check_for_session_reinstatement+0x1e2/0x270
> [<ffffffff81524660>] iscsi_target_check_for_existing_instances+0x30/0x4=
0
> [<ffffffff815247a8>] iscsi_target_do_login+0x138/0x630
> [<ffffffff815259be>] iscsi_target_start_negotiation+0x4e/0xa0
> [<ffffffff8152355e>] __iscsi_target_login_thread+0x83e/0xf20
> [<ffffffff81523c64>] iscsi_target_login_thread+0x24/0x30
> [<ffffffff810a3059>] kthread+0xd9/0xf0
> [<ffffffff817732d5>] ret_from_fork+0x25/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff
>=20
> # cat /proc/21342/stack
> [<ffffffffa0292b10>] __ib_drain_sq+0x190/0x1c0 [ib_core]
> [<ffffffffa0292b65>] ib_drain_sq+0x25/0x30 [ib_core]
> [<ffffffffa0292d72>] ib_drain_qp+0x12/0x30 [ib_core]
> [<ffffffffa062c5ff>] isert_wait_conn+0x5f/0x2d0 [ib_isert]
> [<ffffffff815309b7>] iscsit_close_connection+0x157/0x860
> [<ffffffff8151f10b>] iscsit_take_action_for_connection_exit+0x7b/0xf0
> [<ffffffff81530265>] iscsi_target_rx_thread+0x95/0xa0
> [<ffffffff810a3059>] kthread+0xd9/0xf0
> [<ffffffff817732d5>] ret_from_fork+0x25/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff
>=20
> # ps aux | grep iscsi | grep D
> root     19659  0.0  0.0      0     0 ?        D    16:12   0:00 [iscsi=
_np]
> root     21342  0.0  0.0      0     0 ?        D    16:29   0:00 [iscsi=
_trx]
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

That looks suspiciously like the __ib_drain_sq is stuck forever waiting
on a completion that never comes.

>=20
> On Thu, Dec 15, 2016 at 1:38 PM, Robert LeBlanc <robert@leblancnet.us> =
wrote:
>> Nicholas,
>>
>> I've found that the kernels I used were not able to be inspected using=

>> crash and I could not build the debug info for them. So I built a new
>> 4.9 kernel and verified that I could inspect the crash. It is located
>> at [1].
>>
>> [1] http://mirrors.betterservers.com/trace/crash2.tar.xz
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>
>>
>> On Mon, Dec 12, 2016 at 4:57 PM, Robert LeBlanc <robert@leblancnet.us>=
 wrote:
>>> Nicholas,
>>>
>>> After lots of set backs and having to give up trying to get kernel
>>> dumps on our "production" systems, I've been able to work out the
>>> issues we had with kdump and replicate the issue on my dev boxes. I
>>> have dumps from 4.4.30 and 4.9-rc8 (makedumpfile would not dump, so i=
t
>>> is a straight copy of /proc/vmcore from the crash kernel). In each
>>> crash directory, I put a details.txt file that has the process IDs
>>> that were having problems and a brief description of the set-up at th=
e
>>> time. This was mostly replicated by starting fio and pulling the
>>> Infiniband cable until fio gave up. This hardware also has Mellanox
>>> ConnectX4-LX cards and I also replicated the issue over RoCE using 4.=
9
>>> since it has the drivers in-box. Please let me know if you need more
>>> info, I can test much faster now. The cores/kernels/modules are
>>> located at [1].
>>>
>>> [1] http://mirrors.betterservers.com/trace/crash.tar.xz
>>>
>>> Thanks,
>>> Robert
>>> ----------------
>>> Robert LeBlanc
>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>
>>>
>>> On Fri, Nov 4, 2016 at 3:57 PM, Robert LeBlanc <robert@leblancnet.us>=
 wrote:
>>>> We hit this yesterday, this time it was on the tx thread (the other
>>>> ones before seem to be on the rx thread). We weren't able to get a
>>>> kernel dump on this. We'll try to get one next time.
>>>>
>>>> # ps axuw | grep "D.*iscs[i]"
>>>> root     12383  0.0  0.0      0     0 ?        D    Nov03   0:04 [is=
csi_np]
>>>> root     23016  0.0  0.0      0     0 ?        D    Nov03   0:00 [is=
csi_ttx]
>>>> root     23018  0.0  0.0      0     0 ?        D    Nov03   0:00 [is=
csi_ttx]
>>>> # cat /proc/12383/stack
>>>> [<ffffffff814f24af>] iscsit_stop_session+0x19f/0x1d0
>>>> [<ffffffff814e3c66>] iscsi_check_for_session_reinstatement+0x1e6/0x2=
70
>>>> [<ffffffff814e6620>] iscsi_target_check_for_existing_instances+0x30/=
0x40
>>>> [<ffffffff814e6770>] iscsi_target_do_login+0x140/0x640
>>>> [<ffffffff814e7b0c>] iscsi_target_start_negotiation+0x1c/0xb0
>>>> [<ffffffff814e585b>] iscsi_target_login_thread+0xa9b/0xfc0
>>>> [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>>>> [<ffffffff81721a8f>] ret_from_fork+0x3f/0x70
>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>> # cat /proc/23016/stack
>>>> [<ffffffff814ce0d9>] target_wait_for_sess_cmds+0x49/0x1a0
>>>> [<ffffffffa058b92b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
>>>> [<ffffffff814f2642>] iscsit_close_connection+0x162/0x870
>>>> [<ffffffff814e110f>] iscsit_take_action_for_connection_exit+0x7f/0x1=
00
>>>> [<ffffffff814f122a>] iscsi_target_tx_thread+0x1aa/0x1d0
>>>> [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>>>> [<ffffffff81721a8f>] ret_from_fork+0x3f/0x70
>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>> # cat /proc/23018/stack
>>>> [<ffffffff814ce0d9>] target_wait_for_sess_cmds+0x49/0x1a0
>>>> [<ffffffffa058b92b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
>>>> [<ffffffff814f2642>] iscsit_close_connection+0x162/0x870
>>>> [<ffffffff814e110f>] iscsit_take_action_for_connection_exit+0x7f/0x1=
00
>>>> [<ffffffff814f122a>] iscsi_target_tx_thread+0x1aa/0x1d0
>>>> [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>>>> [<ffffffff81721a8f>] ret_from_fork+0x3f/0x70
>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>
>>>> From dmesg:
>>>> [  394.476332] INFO: rcu_sched self-detected stall on CPU
>>>> [  394.476334]  20-...: (23976 ticks this GP)
>>>> idle=3Dedd/140000000000001/0 softirq=3D292/292 fqs=3D18788
>>>> [  394.476336]   (t=3D24003 jiffies g=3D3146 c=3D3145 q=3D0)
>>>> [  394.476337] Task dump for CPU 20:
>>>> [  394.476338] kworker/u68:2   R  running task        0 12906      2=
 0x00000008
>>>> [  394.476345] Workqueue: isert_comp_wq isert_cq_work [ib_isert]
>>>> [  394.476346]  ffff883f2fe38000 00000000f805705e ffff883f7fd03da8
>>>> ffffffff810ac8ff
>>>> [  394.476347]  0000000000000014 ffffffff81adb680 ffff883f7fd03dc0
>>>> ffffffff810af239
>>>> [  394.476348]  0000000000000015 ffff883f7fd03df0 ffffffff810e1cd0
>>>> ffff883f7fd17b80
>>>> [  394.476348] Call Trace:
>>>> [  394.476354]  <IRQ>  [<ffffffff810ac8ff>] sched_show_task+0xaf/0x1=
10
>>>> [  394.476355]  [<ffffffff810af239>] dump_cpu_task+0x39/0x40
>>>> [  394.476357]  [<ffffffff810e1cd0>] rcu_dump_cpu_stacks+0x80/0xb0
>>>> [  394.476359]  [<ffffffff810e6100>] rcu_check_callbacks+0x540/0x820=

>>>> [  394.476360]  [<ffffffff810afe11>] ? account_system_time+0x81/0x11=
0
>>>> [  394.476363]  [<ffffffff810faa60>] ? tick_sched_do_timer+0x50/0x50=

>>>> [  394.476364]  [<ffffffff810eb599>] update_process_times+0x39/0x60
>>>> [  394.476365]  [<ffffffff810fa815>] tick_sched_handle.isra.17+0x25/=
0x60
>>>> [  394.476366]  [<ffffffff810faa9d>] tick_sched_timer+0x3d/0x70
>>>> [  394.476368]  [<ffffffff810ec182>] __hrtimer_run_queues+0x102/0x29=
0
>>>> [  394.476369]  [<ffffffff810ec668>] hrtimer_interrupt+0xa8/0x1a0
>>>> [  394.476372]  [<ffffffff81052c65>] local_apic_timer_interrupt+0x35=
/0x60
>>>> [  394.476374]  [<ffffffff8172423d>] smp_apic_timer_interrupt+0x3d/0=
x50
>>>> [  394.476376]  [<ffffffff817224f7>] apic_timer_interrupt+0x87/0x90
>>>> [  394.476379]  <EOI>  [<ffffffff810d71be>] ? console_unlock+0x41e/0=
x4e0
>>>> [  394.476380]  [<ffffffff810d757c>] vprintk_emit+0x2fc/0x500
>>>> [  394.476382]  [<ffffffff810d78ff>] vprintk_default+0x1f/0x30
>>>> [  394.476384]  [<ffffffff81174dde>] printk+0x5d/0x74
>>>> [  394.476388]  [<ffffffff814bce21>] transport_lookup_cmd_lun+0x1d1/=
0x200
>>>> [  394.476390]  [<ffffffff814ee8c0>] iscsit_setup_scsi_cmd+0x230/0x5=
40
>>>> [  394.476392]  [<ffffffffa058dbf3>] isert_rx_do_work+0x3f3/0x7f0 [i=
b_isert]
>>>> [  394.476394]  [<ffffffffa058e174>] isert_cq_work+0x184/0x770 [ib_i=
sert]
>>>> [  394.476396]  [<ffffffff8109740f>] process_one_work+0x14f/0x400
>>>> [  394.476397]  [<ffffffff81097c84>] worker_thread+0x114/0x470
>>>> [  394.476398]  [<ffffffff8171d32a>] ? __schedule+0x34a/0x7f0
>>>> [  394.476399]  [<ffffffff81097b70>] ? rescuer_thread+0x310/0x310
>>>> [  394.476400]  [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>>>> [  394.476402]  [<ffffffff8109d6f0>] ? kthread_park+0x60/0x60
>>>> [  394.476403]  [<ffffffff81721a8f>] ret_from_fork+0x3f/0x70
>>>> [  394.476404]  [<ffffffff8109d6f0>] ? kthread_park+0x60/0x60
>>>> [  405.716632] Unexpected ret: -104 send data 360
>>>> [  405.721711] tx_data returned -32, expecting 360.
>>>> ----------------
>>>> Robert LeBlanc
>>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

When you combine this trace with the newest one, it really makes me
thing there is something of a bad interaction between the new drain cq
API and the iser/isert implementation to use said API.  Sagi, Christoph?

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--o4HN48kGU9qe9oohQsJ8r0C0mErVr6tjf--

--JNuHaxVoiQrA0fRPfcBC01PFUMi1MLFsc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXCZfAAoJELgmozMOVy/d81EQAJlzw6IHrw81sccWvY00JjEr
o8zD6zRhtnUsvMU6eS655DxKiFnSRylogqJa+7W5w85Tsh00nEtgMAJePNxDIE5i
OB9WXyAKfUKyDae+/7RIznmpqpxazGnk50pzhq+i8BJIBuIZubEPMCQdMFht8qTO
3OEDTdoPqYI4JmAIxdc0FupwMGMcxDfauJKS/pFlQdQTiN3tmrV5WXf6gospsFUH
35dY+BUSass9+X6l0/yl47w1Nq71FU0T28H6fBXXr4J2kAbJC44DRSAF4AWX9YC6
1a2bay+1IqAmCTvMqw713wh4AiRfsPuzuAuqsL87qQrNIRyZIvQcc3aFdoBvwtun
S5VWoCcOPCqv4DtY8kr96+oPVUK7EKNZxNwYSrbUswgqFKTy6Ky/vT5xw3IYHFXe
cvc5VbGW4gTQ3vbg/wTK2OkvwfIN7OH1VtlvAoInsnDCoq/4qFBwINm8gP72cVmh
7OKw8o6KrHQvrSNOCtOY2LNAVRCTpQZGALmm+So/BPFwl3nF8qM7ts1dC/KwOYLh
GzbCmWwCilNySoCAxGUGzJcIbOQe98UOIuAV6IqBKlg1/aew4lvcAO5FNGNya4i5
pztKbL9bz30sEH3/K8Na5QYCnsOne1UftIOYQXSsx3N9mGvcsxcsfQfJnLb3p8n1
XKQDnEk/91ohfVtwC22t
=4BwZ
-----END PGP SIGNATURE-----

--JNuHaxVoiQrA0fRPfcBC01PFUMi1MLFsc--
