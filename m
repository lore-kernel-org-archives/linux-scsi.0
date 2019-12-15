Return-Path: <SRS0=xzXz=2F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,HK_RANDOM_REPLYTO,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B21C43603
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 07:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3CEB2253D
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 07:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfLOHMx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Dec 2019 02:12:53 -0500
Received: from mout.perfora.net ([74.208.4.197]:46455 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbfLOHMx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Dec 2019 02:12:53 -0500
Received: from [192.168.0.76] ([108.168.115.113]) by mrelay.perfora.net
 (mreueus001 [74.208.5.2]) with ESMTPSA (Nemesis) id 0Luv03-1hgLFT1Khl-01088H;
 Sun, 15 Dec 2019 08:07:30 +0100
Reply-To: tomkcpr@mdevsys.com
Subject: Re: Latest versions of rtslib, configshell and targetcli
From:   TomK <tomkcpr@mdevsys.com>
To:     "J. Roeleveld" <joost@antarean.org>,
        targetcli-fb-devel@lists.fedorahosted.org,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org
References: <486dab9b-e3ad-9fdd-7c1e-511a660de6c0@mdevsys.com>
 <20190328174252.GA30597@infradead.org>
 <1A374E24-19FF-41A9-ADB1-02B020EACC4B@antarean.org>
 <3eb6b1f2-d50a-2465-b1e9-2eddd7c829f9@mdevsys.com>
Message-ID: <7880c75c-f44a-8f32-c5fd-28f2a4db13fc@mdevsys.com>
Date:   Sun, 15 Dec 2019 02:07:27 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <3eb6b1f2-d50a-2465-b1e9-2eddd7c829f9@mdevsys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:7pj9Nm4fkWG1TC5JxafUqskLZSE60XUQdIFXwwyBHb2hekdp6ns
 FOGVaW36wGlX1oGOEqClsmohJ83vOBMx4PZ/BlasA2Ohy+lX/+acS2O3assh24bb0ETkTsq
 iR95+gA9ZeWi/jauu/6WgBTXy2euaQtQD2YdnwgSfnjOc63RgQqdrKIW1RWnw8o1GEyNr62
 5zbA75i4zNkzS6IduyQDA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:oC3p/xhHi6U=:iZvmgs9wgCu/IkYywmlIuY
 /kj98bDdA27shBgirjw5JoecCAj3zfgJt5OXaNxfxTKIboWDqDG27Hoe9+gu3DBzWYFz3hUDa
 iptVVI/G1oTajotTAJLlOIOkiLxP8KhEOtG9bdzG1Nl0BqWuPouxcuvaKZcNbu1lJ22fg+Qz3
 Dy7eF4DzRo/+ToWyZ7aIoDMb5VCIcVOANKYJyWgDyIlu0eYqd7eF6VnlgQpeIdCmezJ4gJV3D
 239EwdHiZV2y7pYa7zFfVlYyZXvSqzq0o2e1jyNthVQmyNEc/4Cf/p1TkQXOS9hEnEI+4w9kL
 s7q0V3H7qHK/0l2J87MhEeERlTajWlvgXmFYciOWF1IJFIzJuWPu6w/Mhb5lfjkoTPwkWfc7F
 stplCgQvgQcPshwbr/7nx+Wtr6eJ2SOeDuDxLcNCvurZxDouVgqgX+LC78f7omAoFmGRXbg8m
 kwGNKld5u9fOc2xx2Pfs9VkoJ3nRxm2xfUmpVuRyxb18XjtCN2HU7XzhvPc4GvTrMocg3FHzD
 tHA2xArXbt5fEnmeGHs4NS1n+LOz4UyPrBOMrWKmD9ciZng4w8UUl2qvgWmyfJ2M3bCIBPB8o
 qZw8K/9mrO3lBG0dfa3WTecYIHP/CWRsZriXANOH26r2CjXsFG2FwOWKhdMYb5vyVdx1EsBa/
 CA51qv4qsQpVlFNVwl6ljhVFfYSSBeWogbpz8eht0Sa9HnrZJINuv10jGa1eBa7Btp+XvDql8
 WlKUA42N590eOYAC+6aFOK4KOvnQzqZF1bzgx7INZFeBBu2mY4rbDL0334hkIk5M+qUYl5bZh
 FbFsdgUZyy2wYkDiJj72/bQ2dIsoXQtvmCxuXrg0XcisFUClNS6e+HHRC0PAFbTDFWUKvdjYE
 39ky3GnVxEAeKGEVuK0UkYY3vx+h8mwqPzEpG6ZMM=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allright.  Gave the -fb versions a try.

790037 -rw-r--r--.   1 root root 18100 Dec 14 23:22 scsi_target.lio
786433 drwxr-xr-x. 155 root root 12288 Dec 14 23:52 ..
787390 -rw-------.   1 root root    71 Dec 15 01:43 saveconfig.json

They use json instead of the old .lio format for storing the config. 
And so won't let me restore my old config:


/> restoreconfig /etc/target/scsi_target.lio
Error parsing savefile: /etc/target/scsi_target.lio
/>


The -fb version however supports the force_pr_aptpl option:

config# load /etc/target/scsi_target.lio
Replace the current configuration with /etc/target/scsi_target.lio? [y/N] y

*** Unknown attribute: storage fileio disk mdsesxip01-d01.img attribute 
force_pr_aptpl
config#

[root@nexus01 target]# grep -EiR force_pr_aptpl *

targetcli-fb/build/targetcli-fb-2.1.51.2.g94d971d/targetcli/ui_backstore.py: 
        'force_pr_aptpl': ('number', 'If set to 1, force SPC-3 PR 
Activate Persistence across Target Power Loss operation.'),
targetcli-fb/targetcli/ui_backstore.py:        'force_pr_aptpl': 
('number', 'If set to 1, force SPC-3 PR Activate Persistence across 
Target Power Loss operation.'),

So just want to bring up the question once more: which version of 
targetcli, rtslib and configshell did folks here find most compatible? 
Still the -fb version?

Thx,
TK

On 4/7/2019 12:30 AM, TomK wrote:
> On 3/28/2019 1:53 PM, J. Roeleveld wrote:
>> On March 28, 2019 5:42:52 PM UTC, Christoph Hellwig 
>> <hch@infradead.org> wrote:
>>
>>     On Fri, Mar 22, 2019 at 11:26:13PM -0400, TomK wrote:
>>
>>         Hey All,
>>
>>         I'm wondering if there are newer versions of the following
>>         packages still
>>         available and where I could download them from? The github link
>>         hasn't
>>         been updated in quite some time:
>>
>>
>>     I think you want to look for the versions with the -fb postfix.  They
>>     aren't 100% compatible, but a lot more actively maintained.
>>
>>     I've Cced the mailing list for the project, although I haven't gotten
>>     a single mail from that list for more than a year either..
>>     
>> ------------------------------------------------------------------------
>>     targetcli-fb-devel mailing list -- 
>> targetcli-fb-devel@lists.fedorahosted.org
>>     To unsubscribe send an email to 
>> targetcli-fb-devel-leave@lists.fedorahosted.org
>>     Fedora Code of Conduct:https://getfedora.org/code-of-conduct.html
>>     List 
>> Guidelines:https://fedoraproject.org/wiki/Mailing_list_guidelines
>>     List 
>> Archives:https://lists.fedorahosted.org/archives/list/targetcli-fb-devel@lists.fedorahosted.org 
>>
>>
>>
>> I have been using the -fb versions for a while now and not had any 
>> issues with them.
>> You do need to use either the -fb versions for all, or the non-fb 
>> versions for all. Mix and match is not supported and can lead to 
>> strange results (if it even works).
>>
>> I also don't remember getting any emails on this list for a while either.
>>
>> -- 
>> Joost
>> -- 
>> Sent from my Android device with K-9 Mail. Please excuse my brevity.
> 
> Thanks all!
> 
> If targetcli or the -fb version isn't maintained much anymore, I'm 
> wondering what else I could use in it's place?
> 


-- 
Thx,
TK.
