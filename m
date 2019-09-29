Return-Path: <SRS0=tdrW=XY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,HK_RANDOM_REPLYTO,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 429C6C4360C
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Sep 2019 17:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1E2F2082F
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Sep 2019 17:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfI2ROl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Sep 2019 13:14:41 -0400
Received: from mout.perfora.net ([74.208.4.197]:33367 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfI2ROl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Sep 2019 13:14:41 -0400
Received: from [192.168.0.76] ([108.168.115.11]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1MXYdX-1iefGS3eGN-00Z1c8
 for <linux-scsi@vger.kernel.org>; Sun, 29 Sep 2019 19:14:39 +0200
Reply-To: tomkcpr@mdevsys.com
Subject: Re: Pick up new LUN size.
From:   TomK <tomkcpr@mdevsys.com>
To:     linux-scsi@vger.kernel.org
References: <9115cdea-f419-e155-0f9a-2f0dedafef0e@mdevsys.com>
Message-ID: <fc42e277-16de-b14d-2b94-cffd24a681dc@mdevsys.com>
Date:   Sun, 29 Sep 2019 13:14:37 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9115cdea-f419-e155-0f9a-2f0dedafef0e@mdevsys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dYQurt25VCwXTIFlJfKXFafFqF0K56+c03LHEq0vZPumXNicmdl
 PqakXOULDO8/WPu6aGIu/9Jer/igav7U48cdb8KAxjqrKLpRz5gaS2ZGJ/W2iC7GgE3IC+q
 kj9AE4Z1gym3VjNdUUS9V6h4qpubAZEI81h9hpIgfQDhZ4grI2Sb+SJXXxdIe9GCqaIObaL
 bcR0RcIclvb59a3ek5EwQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:34TyUgriSI0=:+RkogWFBMvETrfyVTquanP
 zUkiLtV6r4aE3i32tPp/Vhbu+AcpfDO2/Dc4v2ob9/csB8MvbrYee/REivUiQHsE0FiUSy8z+
 5g7gBHsMSRIwTvAwpUUWBHqin0ujfjzgRDjob+hel6QZZa0TQDeZbKoXiAZNTDsjMLoiNEigQ
 ySPJxzps0stEZPBvQ8e3cWXzXFVLExNbjhJ9l/jQcb3oZ+SjB0H65iIWB3DxYrVYtiSz+VkMK
 iBhU19xi80FQ2osOc1gtVkQNCfMQiF14bnVIDgEHS/ql4AKdEM1QNYyGWUY5haS++xdqUN8gk
 bJUJHxpqIFP3m6qxRslalWRxxEFxkEjNiTyt15kf6kAF7F/FAoZG/Q3nhvljfIzU6+/R16/lZ
 V3PI7uUvHzB8oNoJYkT0x5v55s6VSVJD2zV+jKN7B0/FHUwv9SVXBFg9Sk0ffT+ZXkBmD/1wF
 lYhcjD5pz1J+wjB/1X3UKnsjvNTwxQa7mgxq8iWjlhEQpVJ9BmTPykaAomlrPIe8Z/lmJHAjo
 zyktkOg4FobwEMfGZsrI2UWnPQH49Mml1EAR14dhYPhx22YmueHHHJr4plx9sr8C5/Vlld8yS
 921/5RRAqgSv/wwsnCTcW6WlyijDlcMZMfOyx/ARk5YRaufHtxXYhyrKBwilKgHf0taVYEIpC
 3Yd3WdSZWF/WbqmMYQCM686Bo6ZZ77gAtRhq8Hl0jyBUyXY+IaXfK0LhWap8lh+NTMCcotvUY
 QqZYk5UzihEFVsOz/R57U1O+9W6YSQgXs1NfYlJj74NyzQ5EXZ9oNjCO5d1pd3gte5oDF2Ifo
 3VmkgDmMxo5B0ZxQvD96/8cyOG6Yjp6Du4SfaPtgguI8OEM9ZiR+XNiYORdv3VIq3nZ3z6BRe
 HQCd8MYWREDIoxaaXUya0nCkFk0muQSGR5SnxO6qY=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/2019 12:48 AM, TomK wrote:
> Hey All,
> 
> I've changed the size of /mnt/luns/san-luns/host01-disk01.img on disk. 
> Now I would like to change the size visible in targetcli.  How could I 
> do that?
> 
> /backstores/fileio> ls
> o- fileio 
> ...................................................................................................... 
> [4 Storage Objects]
>    o- host01-disk01.img ........................................ [2.0T, 
> /mnt/luns/san-luns/host01-disk01.img, in use]
> /backstores/fileio>
> 
> 

I've managed to change the size by deleting the fileio object and 
recreating it in the absence of a way to resize without having to do 
that.  But did run into an issue with targetcli:

You may run into this error:

/> saveconfig
Save configuration? [Y/n]: Y
Performing backup of startup configuration: 
/var/target/backup-2019-09-29_12:13:23.lio
Saving new startup configuration
Traceback (most recent call last):
   File "/usr/lib/python2.6/site-packages/configshell/shell.py", line 
990, in run_interactive
     self._cli_loop()
   File "/usr/lib/python2.6/site-packages/configshell/shell.py", line 
813, in _cli_loop
     self.run_cmdline(cmdline)
   File "/usr/lib/python2.6/site-packages/configshell/shell.py", line 
934, in run_cmdline
     self._execute_command(path, command, pparams, kparams)
   File "/usr/lib/python2.6/site-packages/configshell/shell.py", line 
909, in _execute_command
     result = target.execute_command(command, pparams, kparams)
   File "/usr/lib/python2.6/site-packages/targetcli/ui_node.py", line 
104, in execute_command
     pparams, kparams)
   File "/usr/lib/python2.6/site-packages/configshell/node.py", line 
1405, in execute_command
     result = method(*pparams, **kparams)
   File "/usr/lib/python2.6/site-packages/targetcli/ui_node.py", line 
123, in ui_command_saveconfig
     CliConfig.save_running_config()
   File "/usr/lib/python2.6/site-packages/targetcli/cli_config.py", line 
65, in save_running_config
     config.load_live()
   File "/usr/lib/python2.6/site-packages/rtslib/config.py", line 563, 
in load_live
     parse_tree = self._parser.parse_string(live)
   File "/usr/lib/python2.6/site-packages/rtslib/config_parser.py", line 
148, in parse_string
     return self._parser.parseString(string, parseAll=True).asList()
   File "/usr/lib/python2.6/site-packages/pyparsing.py", line 1032, in 
parseString
     raise exc
ParseException: Expected end of text (at char 3660), (line:116, col:1)
/>

Same on save:

/> exit
Comparing startup and running configs...
Expected end of text (at char 3660), (line:116, col:1)
You have mail in /var/spool/mail/root
[root@mbpc-pc san-luns-scst]#

When does this happen?

When deleting a LUN and readding it with greater size, it doesn't really 
update the config file on disk and is thereby possibly unable to add the 
new LUN under the old name?

/qla2xxx/21:0...81:81:21/luns> ls
o- luns 
................................................................................................................... 
[4 LUNs]
   o- lun0 ........................................ 
[fileio/mdsovirtp01-d01.img 
(/mnt/HTPCBackupXFS/san-luns-scst/mdsovirtp01-d01.img)]
   o- lun1 .......................................... 
[fileio/mdskvmp01-d01.img 
(/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp01-d01.img)]
   o- lun2 ....................................... 
[fileio/mdskvmp02-d01.img_13 
(/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp02-d01.img)]
   o- lun3 .......................................... 
[fileio/mdskvmp03-d01.img 
(/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp03-d01.img)]
/qla2xxx/21:0...81:81:21/luns>


Moreover, when REcreating the /backstore/fileio/, the new disk 
disappears without apparent reason:

/backstores/fileio> create mdskvmp02-d01.img 
/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp02-d01.img 4T
Using buffered mode.
Created fileio mdskvmp02-d01.img.
/backstores/fileio> ls
o- fileio 
...................................................................................................... 
[4 Storage Objects]
   o- mdsovirtp01-d01.img ........................................ 
[2.0T, /mnt/HTPCBackupXFS/san-luns-scst/mdsovirtp01-d01.img, in use]
   o- mdskvmp01-d01.img .......................................... 
[4.0T, /mnt/HTPCBackupXFS/san-luns-scst/mdskvmp01-d01.img, in use]
   o- mdskvmp02-d01.img ...................................... [4.0T, 
/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp02-d01.img, not in use]
   o- mdskvmp03-d01.img .......................................... 
[2.0T, /mnt/HTPCBackupXFS/san-luns-scst/mdskvmp03-d01.img, in use]
/backstores/fileio> cd cd /qla2xxx/21:00:00:1b:32:81:81:21/luns/
Got 2 positionnal parameters, expected at most 1.
/backstores/fileio> cd /qla2xxx/21:00:00:1b:32:81:81:21/luns/
/qla2xxx/21:0...81:81:21/luns> ls
o- luns 
................................................................................................................... 
[3 LUNs]
   o- lun0 ........................................ 
[fileio/mdsovirtp01-d01.img 
(/mnt/HTPCBackupXFS/san-luns-scst/mdsovirtp01-d01.img)]
   o- lun1 .......................................... 
[fileio/mdskvmp01-d01.img 
(/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp01-d01.img)]
   o- lun3 .......................................... 
[fileio/mdskvmp03-d01.img 
(/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp03-d01.img)]
/qla2xxx/21:0...81:81:21/luns> create 
storage_object=/backstores/fileio/mdskvmp02-d01.img lun=2 
add_mapped_luns=false
Invalid storage object /backstores/fileio/mdskvmp02-d01.img.
/qla2xxx/21:0...81:81:21/luns>

(We are not in the configure mode btw)  Noticed in the static config 
file on disk that hasn't been saved yet, that the old entry still exists 
despite removing it from above.  Not sure if that matters though:

[root@mbpc-pc target]# view scsi_target.lio
     disk mdskvmp02-d01.img {
         buffered yes
         path /mnt/HTPCBackupXFS/san-luns-scst/mdskvmp02-d01.img
         size 4.0TB
         wwn e85336b5-2c9b-42c0-985e-b62b10bdce6f
         attribute {

So exited, waited a few minutes and reentered targetcli and recreated 
the entries with a higher size.  At this point, the error disappeared 
and we were able to save again.  The underscore under the LUN's section 
also disappeared.  The final result was a clean save:

/> ls
o- / 
......................................................................................................................... 
[...]
   o- backstores 
.............................................................................................................. 
[...]
   | o- fileio 
.................................................................................................. 
[4 Storage Objects]
   | | o- mdsovirtp01-d01.img .................................... 
[2.0T, /mnt/HTPCBackupXFS/san-luns-scst/mdsovirtp01-d01.img, in use]
   | | o- mdskvmp01-d01.img ...................................... 
[4.0T, /mnt/HTPCBackupXFS/san-luns-scst/mdskvmp01-d01.img, in use]
   | | o- mdskvmp02-d01.img ...................................... 
[4.0T, /mnt/HTPCBackupXFS/san-luns-scst/mdskvmp02-d01.img, in use]
   | | o- mdskvmp03-d01.img ...................................... 
[2.0T, /mnt/HTPCBackupXFS/san-luns-scst/mdskvmp03-d01.img, in use]
   | o- iblock 
................................................................................................... 
[0 Storage Object]
   | o- pscsi 
.................................................................................................... 
[0 Storage Object]
   | o- rd_mcp 
................................................................................................... 
[0 Storage Object]
   o- iscsi 
............................................................................................................. 
[0 Targets]
   o- loopback 
.......................................................................................................... 
[0 Targets]
   o- qla2xxx 
........................................................................................................... 
[2 Targets]
   | o- 21:00:00:1b:32:81:81:21 
........................................................................................... 
[enabled]
   | | o- acls 
............................................................................................................. 
[4 ACLs]
   | | | o- 21:00:00:1b:32:00:83:b3 
.................................................................................. 
[1 Mapped LUN]
   | | | | o- mapped_lun0 
............................................................................................... 
[lun2 (rw)]
   | | | o- 21:03:00:1b:32:74:b6:cb 
.................................................................................. 
[1 Mapped LUN]
   | | | | o- mapped_lun0 
............................................................................................... 
[lun3 (rw)]
   | | | o- 50:01:43:80:16:77:99:38 
.................................................................................. 
[1 Mapped LUN]
   | | | | o- mapped_lun0 
............................................................................................... 
[lun0 (rw)]
   | | | o- 50:01:43:80:16:77:99:70 
.................................................................................. 
[1 Mapped LUN]
   | | |   o- mapped_lun0 
............................................................................................... 
[lun1 (rw)]
   | | o- luns 
............................................................................................................. 
[4 LUNs]
   | |   o- lun0 .................................. 
[fileio/mdsovirtp01-d01.img 
(/mnt/HTPCBackupXFS/san-luns-scst/mdsovirtp01-d01.img)]
   | |   o- lun1 .................................... 
[fileio/mdskvmp01-d01.img 
(/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp01-d01.img)]
   | |   o- lun2 .................................... 
[fileio/mdskvmp02-d01.img 
(/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp02-d01.img)]
   | |   o- lun3 .................................... 
[fileio/mdskvmp03-d01.img 
(/mnt/HTPCBackupXFS/san-luns-scst/mdskvmp03-d01.img)]
   | o- 21:01:00:1b:32:a1:81:21 
........................................................................................... 
[enabled]
   |   o- acls 
............................................................................................................. 
[0 ACLs]
   |   o- luns 
............................................................................................................. 
[0 LUNs]
   o- vhost 
............................................................................................................. 
[0 Targets]
/> saveconfig
Save configuration? [Y/n]: Y
Performing backup of startup configuration: 
/var/target/backup-2019-09-29_12:23:06.lio
Saving new startup configuration
/> exit
Comparing startup and running configs...
Startup config is up-to-date.
You have mail in /var/spool/mail/root
[root@mbpc-pc san-luns-scst]#

ISSUE REF: https://github.com/Datera/targetcli/issues/21

Has anyone seen this as well?

Using this one:

targetcli-3.0.pre4.5~ga125182-1.el6.noarch

-- 
Thx,
TK.
