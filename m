Return-Path: <SRS0=tdrW=XY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,HK_RANDOM_REPLYTO,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C3EC4360C
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Sep 2019 17:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D129121835
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Sep 2019 17:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfI2REu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Sep 2019 13:04:50 -0400
Received: from mout.perfora.net ([74.208.4.194]:55139 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfI2REu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Sep 2019 13:04:50 -0400
Received: from [192.168.0.76] ([108.168.115.11]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1MOznU-1iV4e80C4q-00PR08;
 Sun, 29 Sep 2019 19:04:44 +0200
Reply-To: tomkcpr@mdevsys.com
Subject: Re: Kernel panic w/ message request_threaded_irq ->
 qla2x00_request_irqs -> qla2x00_probe_one -> mod_timer
From:   TomK <tomkcpr@mdevsys.com>
To:     Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <012262e1-697c-577b-cf99-bbd960661c70@mdevsys.com>
 <749372e4ebd5857ecc9b0947d6f8582a6f199bf4.camel@redhat.com>
 <1555342788.161891.95.camel@acm.org>
 <d6cef9727e9446101a9913651d58df60914c7b61.camel@redhat.com>
 <fa7e07d1-5266-4f55-b3f5-f41a85e679d8@mdevsys.com>
 <8ab70c91-9e11-4e8b-f4cf-d705bec1d4c1@mdevsys.com>
 <156112a88d3bc8e2edc32253e4b19f62b6254580.camel@redhat.com>
 <b6afdebe-f43a-2534-0b78-21c85dd3a8f8@mdevsys.com>
 <003a89f7-7077-d9f1-75e5-bc0de6d6e038@mdevsys.com>
Message-ID: <f9fe319e-a100-66fe-d496-12e229ed5cb1@mdevsys.com>
Date:   Sun, 29 Sep 2019 13:04:40 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <003a89f7-7077-d9f1-75e5-bc0de6d6e038@mdevsys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dNiLF5b5ZYNmXtZ+GvxhE5u6Y0DnuxLi1hMLc+hjQisO84FLaue
 le+qlCQ8ZecVfZYgbCGladVuTzpidQFM1PckFyUsH+p6omLx9X3iIBKDM5dExH3Tev7/1bt
 QLlyVBGAB9HnJrXuMd5sUMPgWk6xQ1NF9dp4GzI1lpTC7Vpd7q9mTW06nX8x6MXc2rdLcY3
 VRL2PwmfuCbph9MLLInNA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:4B+xz71xXGs=:inanZ1TURWPTyXuXwTtm0d
 aKor+SnnsXo6veumTVoWtBsaW0av+rogOHCOLg6Gu8jW9HbrVXSf9FLMM4RaUik3zTuj6zy7z
 U81fK/mIFBA++QUeHaBjH6V4n5o/hf5jLBY8RMyubjkeo3CsqENUN/Obkm1tBDAUDeUPDESZu
 DZU1mIQbjOt1JA/H8PQwlXZjoJdOU2OU/3v5WGnFzz9yjdorpL3U5sHFcyueRxaJvFkAMsXXf
 g5+5OZEPeQ/3I5bKek2kutDzUHCUycb/D9TT9bPW3vonVTan1bW68EQhl0RAcU9VY4eMgBarW
 mE2/42BiBdzKFVNmvcJOK/p5IlRMYO8shyXDcJ9/hb+G3g6usBa5g3yXVL27x8S/zHIXOD/vf
 UIJbRquTgft6BBoU8bbDVTo0tEMTRTc+1+ns2OaO+y51/WSEFfqtzGzp7x/nRdS0fXcJx8xGT
 rQbSfnyuwROBHtyhkECDSgwxXO66HR8cjrvAzr1cnzQefa5PznLNfJrdlxPJVijy7drdcjqmB
 c+7TH7ZydUMdRmqqDDzKJYoxE8yfAL0Gx47bk1R2JJf2Lj0QTHBUh6Tybe0yqrhz+YU6YBMOT
 eJoKv5YAF7mIbFbkyQXFhhB0v+NpsZfAMW7rTbogdEfywj11SN7I/O6zB/SibW0SVDuQPy6BG
 odNhKxo37OC/Fm7IUiprjoIKvQuTsFzSBu1l1QVVllj+YyrHbpiOqSieeBcsiFCCq/G+ryqHO
 7x8sm5QFCOMK5V42nsK84eIOT6bumBB7UM7JmkahJAjarFFtvqTtZHwZvTpUrXcpJb1TFBiS/
 dsSCS5d5FKHto5NceKBGC2g8KJM43Ze2FqjfPkuWdMgO7RaTAj0C769mLgcHNBljCN/SCIsUe
 cd3CSfN5g/JANssyHYEH/o+n5W/y9tni1Kqa/sIBs=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/12/2019 11:56 PM, TomK wrote:
> On 5/3/2019 9:07 AM, TomK wrote:
>> On 5/2/2019 10:00 PM, Laurence Oberman wrote:
>>> On Sun, 2019-04-28 at 12:11 -0400, TomK wrote:
>>>> On 4/15/2019 10:26 PM, TomK wrote:
>>>>> On 4/15/2019 3:35 PM, Laurence Oberman wrote:
>>>>>> On Mon, 2019-04-15 at 08:39 -0700, Bart Van Assche wrote:
>>>>>>> On Mon, 2019-04-15 at 08:55 -0400, Laurence Oberman wrote:
>>>>>>>> On Sun, 2019-04-14 at 23:25 -0400, TomK wrote:
>>>>>>>>> Hey All,
>>>>>>>>>
>>>>>>>>> I'm getting a kernel panic on an Gigabyte GA-890XA-UD3
>>>>>>>>> motherboard
>>>>>>>>> that
>>>>>>>>> I've got a QLE2464 card in as a target (FC).  The kernel
>>>>>>>>> has
>>>>>>>>> been
>>>>>>>>> crashing / panicking in the last 1-2 months about once a
>>>>>>>>> week.  Before
>>>>>>>>> that, it was rock solid for 4-5 years.  I've upgraded to
>>>>>>>>> kernel
>>>>>>>>> 4.18.19
>>>>>>>>> but that hasn't made much of a difference.  Since the
>>>>>>>>> message
>>>>>>>>> includes
>>>>>>>>> qla2x00_request_irqs I thought I would try here first.
>>>>>>>>>
>>>>>>>>> Tried to get more info on this but:
>>>>>>>>>
>>>>>>>>> 1) Keyboard doesn't work and locks up when the panic
>>>>>>>>> occurs.  No
>>>>>>>>> USB
>>>>>>>>> ports work.  Tried the PS/2 port but nothing.
>>>>>>>>>
>>>>>>>>> 2) Unable to capture a kdump.  Can't get to the kdump
>>>>>>>>> vmcore due
>>>>>>>>> to
>>>>>>>>> 1).
>>>>>>>>>
>>>>>>>>> The two screenshots is pretty much all I can capture.
>>>>>>>>> Tried
>>>>>>>>> things
>>>>>>>>> like
>>>>>>>>> clocksource=rtc in the kernel parms and disabling hpet1
>>>>>>>>> but
>>>>>>>>> apparently I
>>>>>>>>> haven't disabled it everywhere since it still shows up.
>>>>>>>>>
>>>>>>>>> Wondering if anyone recognizes these messages or has any
>>>>>>>>> idea
>>>>>>>>> what
>>>>>>>>> could
>>>>>>>>> be the issue here?  Even a hint would be appreciated.
>>>>>>>>>
>>>>>>>> Hello Tom
>>>>>>>> I have had similar issues and reported them to
>>>>>>>> Himanshu@Cavium
>>>>>>>> I have kept all my target servers at kernel 4.5 as it been
>>>>>>>> the only
>>>>>>>> version that has always been stable.
>>>>>>>> If your motherboard has an NMI (virtual or physical) set all
>>>>>>>> of
>>>>>>>> these
>>>>>>>> in /etc/sysctl.conf
>>>>>>>> Run sysctl -a;dracut -f and reboot
>>>>>>>>
>>>>>>>> kernel.nmi_watchdog = 1
>>>>>>>> kernel.panic_on_io_nmi = 1
>>>>>>>> kernel.panic_on_unrecovered_nmi =
>>>>>>>> kernel.unknown_nmi_panic = 1
>>>>>>>>
>>>>>>>> When the issue shows up press the virtual/physical NMI
>>>>>>>>
>>>>>>>> This is with the assumption that generic kdump is properly
>>>>>>>> setup
>>>>>>>> and
>>>>>>>> dmesg | grep crash shows memory resrved by the crashkernel
>>>>>>>> and that
>>>>>>>> you
>>>>>>>> have tested kdump manually.
>>>>>>>>
>>>>>>>> Other options are use a USB serial port to capture the full
>>>>>>>> log if
>>>>>>>> you
>>>>>>>> cannot get kdump to work.
>>>>>>> That approach may provide further evidence about kernel bugs
>>>>>>> but it
>>>>>>> is not
>>>>>>> guaranteed that that approach will lead to a solution. It would
>>>>>>> help
>>>>>>> if
>>>>>>> either or both of you could do the following on a test system:
>>>>>>> * Check out branch qla2xxx-for-next of my kernel repo on
>>>>>>> github
>>>>>>>     (https://github.com/bvanassche/linux/tree/qla2xxx-for-next).
>>>>>>> * Enable lockdep and KASAN in the kernel config
>>>>>>> (CONFIG_PROVE_LOCKING
>>>>>>> and
>>>>>>>     CONFIG_KASAN).
>>>>>>> * Build and install that kernel.
>>>>>>> * Run your favorite workload.
>>>>>>>
>>>>>>> Please note that the qla2xxx-for-next branch is based on the
>>>>>>> v5.1-rc1
>>>>>>> kernel
>>>>>>> and hence should not be installed on any production system.
>>>>>>>
>>>>>>> Thanks,
>>>>>>>
>>>>>>> Bart.
>>>>>> Hello Bart
>>>>>> OK, I will get to this by Thursday, wont be able to change the
>>>>>> targetserver kernel until then.
>>>>>> Regards
>>>>>> Laurence
>>>>>>
>>>>> Same.  I'll try this out closer to the weekend.
>>>>>
>>>>> Not an NMI motherboard.  This is a 9-10 year old AMD board meant as
>>>>> a desktop or home server.
>>>>>
>>>>> I'll have to read more about the USB Serial port to capture further
>>>>> info.  That's interesting.
>>>>>
>>>>> For the time being, I've disabled HPET in BIOS.  ( Appears the
>>>>> kernel boot parameter method wasn't enough. )
>>>>>
>>>>>
>>>>
>>>> Hey Guy's,
>>>> Did some of what you suggested, including the USB serial setup:
>>>> 1) One of DB9 RS232 Serial Null Modem Cable F/F
>>>> 2) Two of USB to RS232 Serial Port DB9 9 Pin Male
>>>> however, when the kernel came down it took the USB support with it
>>>> and so minicom went offline:
>>>>   CTRL-A Z for help |115200 8N1 | NOR | Minicom 2.6.2  | VT102 |
>>>> Offline
>>>> But I did enable full logging for the QLA module:
>>>> echo 0x7fffffff >
>>>> /sys/module/qla2xxx/parameters/ql2xextended_error_logging
>>>> Did all that, minus the Kernel v5.1-rc1 implementation, and this is
>>>> what was picked up from the minicom USB to Serial capture before
>>>> things went south:
>>>> 1235905 ^Mqla2xxx [0000:04:00.0]-e818: is_send_status=1, cmd-
>>>>> bufflen=512, cmd->sg_cnt=1, cmd-
>>>> dma_data_directi
>>>>                               on=1
>>>> se_cmd[0000
>>>>                          00009c9ea758]
>>>> qp
>>>>                  0
>>>> 1235906 ^Mqla2xxx [0000:04:00.0]-e818: is_send_status=1, cmd-
>>>>> bufflen=4096, cmd->sg_cnt=0,
>>>> cmd-
>>>>> dma_data_direct
>>>>                               ion=2
>>>> se_cmd[000
>>>>                         0000096ae11b7]
>>>> q
>>>>                p 0
>>>> 1235907 ^Mqla2xxx [0000:04:00.0]-e818: is_send_status=1, cmd-
>>>>> bufflen=20480, cmd->sg_cnt=0,
>>>> cmd
>>>> ->dma_data_direc
>>>>                               tion=2
>>>> se_cmd[00
>>>> 0000001738f793]
>>>>                               qp 0
>>>> 1235908 ^Mqla2xxx [0000:04:00.0]-e818: is_send_status=1, cmd-
>>>>> bufflen=20480, cmd->sg_cnt=0,
>>>> cmd
>>>> ->dma_data_direc
>>>>                               tion=2
>>>> se_cmd[00
>>>> 000000e8160a90]
>>>>                               qp 0
>>>> 1235909 ^MDetected MISCOMPARE for addr: 0000000033045258 buf:
>>>> 00000000f9849912
>>>> 1235910 ^MTarget/fileio: Send MISCOMPARE check condition and sense
>>>> 1235911 ^Mqla2xxx [0000:04:00.0]-e818: is_send_status=1, cmd-
>>>>> bufflen=512, cmd->sg_cnt=0, cmd-
>>>> dma_data_directi
>>>>                               on=2
>>>> se_cmd[0000
>>>>                          0000363ae214]
>>>> qp
>>>>                  0
>>>> 1235912 ^Mqla2xxx [0000:04:00.0]-e817: Skipping EXPLICIT_CONFORM and
>>>> CTIO7_FLAGS_CONFORM_REQ
>>>> fo
>>>>               r FCP READ w/
>>>> no
>>>>                 n GOOD status
>>>> 1235913 ^Mqla2xxx [0000:04:00.0]-e874:2: qlt_free_cmd:
>>>> se_cmd[000000001db805fd] ox_id 00c8
>>>> 1235914 ^Mqla2xxx [0000:04:00.0]-e872:2: qlt_24xx_atio_pkt_all_vps:
>>>> qla_target(0): type 6
>>>> ox_id
>>>>                   00db
>>>> 1235915 ^Mqla2xxx [0000:04:00.0]-e872:2: qlt_24xx_atio_pkt_all_vps:
>>>> qla_target(0): type 6
>>>> ox_id
>>>>                   00dc
>>>> 1235916 ^Mqla2xxx [0000:04:00.0]-e874:2: qlt_free_cmd:
>>>> se_cmd[00000000f67a701f] ox_id 00c9
>>>> 1235917 ^Mqla2xxx [0000:04:00.0]-e872:2: qlt_24xx_atio_pkt_all_vps:
>>>> qla_target(0): type 6
>>>> ox_id
>>>>                   00dd
>>>> 1235918 ^Mqla2xxx [0000:04:00.0]-e872:2: qlt_24xx_atio_pkt_all_vps:
>>>> qla_target(0): type 6
>>>> ox_id
>>>>                   00de
>>>>
>>>> On an earlier crash, captured the attached image.  This time there
>>>> was nothing on the monitor and the keyboard didn't refresh it.  No
>>>> signal.
>>>> When looking this up, closest I could see online is the following:
>>>>
>>> https://target-devel.vger.kernel.narkive.com/XiM5Csx8/luns-become-unavailable-with-current-git-head 
>>>
>>>> They too run ESXi .
>>>> To read the file I used the AnsiEsc plugin for VIM:
>>>> https://www.vim.org/scripts/script.php?script_id=302
>>>> This started to occur once had a VMware based MySQL and PostgreSQL
>>>> cluster configured.  Takes a few days for the issue to occur so from
>>>> that perspective, appears to be memory related.
>>>> Firmware that I'm using is:
>>>>      supported_classes   = "Class 3"
>>>>      supported_speeds    = "1 Gbit, 2 Gbit, 4 Gbit"
>>>>      symbolic_name       = "QLE2464 FW:v8.04.00 DVR:v10.00.00.05-k"
>>>> Targetcli, rtslib and configshell versions I'm using are:
>>>>
>>>> # rpm -aq|grep -Ei "targetcli|rtslib|configshell"
>>>> python-rtslib-3.0.pre4.9~g6fd0bbf-1.el6.noarch
>>>> python-configshell-1.1.fb4-1.el6.noarch
>>>> targetcli-3.0.pre4.5~ga125182-1.el6.noarch
>>>>
>>>>
>>>> -- 
>>>> Thx,
>>>> TK.
>>>
>>> I missed this email, Been buried in customer cases.
>>> I also need to still run some tests.
>>> Sorry, reading now
>>>
>>
>> No worries.  Would be very interested to see what you find.
>>
>> In the meantime later tonight I'll be trying to 1) find more recent 
>> firmware for the card, 2) try to use the newer kernel v5.1-rc1 
>> outlined above 3) try the 4.5 kernel later on the weekend.
>>
>>
> 
> 
> Trying with this F/W and driver:
> 
> 
> symbolic_name       = "QLE2464 FW:v8.06.02 DVR:v10.00.00.07-k-debug"
> 
> [root@mbpc-pc 05-03-2019]# strings /lib/firmware/ql2400_fw.bin|grep -Ei 
> copyright
>   COPYRIGHT 2016 QLOGIC CORPORATION   ISP24xx Firmware   Version 8.06.02  $
> [root@mbpc-pc 05-03-2019]#
> 
> 
> 
> The latest 'boot' firmware I can find is the following:
> 
> 
> 
> [root@mbpc-pc 05-03-2019]# strings Q24A7232.BIN |grep -Ei copyright
> Copyright (C) QLogic Corporation 1993-2015. All rights reserved.
> Copyright (C) QLogic Corporation 1993-2015. All rights reserved.
>   COPYRIGHT 2015 QLOGIC CORPORATION   ISP24xx Firmware   Version 8.01.02  $
> You have new mail in /var/spool/mail/root
> [root@mbpc-pc 05-03-2019]#
> 
> This is what shows up as loaded during system boot.
> 

So resolved it a few months back.  What I did is simply to upgrade the 
memory on the storage server from 4GB to 8GB.  Then later to 16GB. 
Since the time I upgrade the memory, the kernel panic didn't show up and 
everything's been stable.

-- 
Thx,
TK.
