From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: dm-multipath test scripts
Date: Thu, 8 Oct 2015 23:10:34 +0000
Message-ID: <20151008231033.GA3952@xzibit.linux.bs1.fc.nec.co.jp>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <1444203081.3958.2.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:60410 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbbJHXLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2015 19:11:15 -0400
In-Reply-To: <1444203081.3958.2.camel@suse.de>
Content-Language: ja-JP
Content-ID: <EAC4FEFD2E06D24EAFF05934C2D296A0@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 10/07/15 16:31, Johannes Thumshirn wrote:
> On Wed, 2015-10-07 at 05:39 +0000, Junichi Nomura wrote:
>> This is a set of scripts for kernel-side dm-multipath testing.
>> Current
>> set of scripts are stress testing of extreme situation and its
>> coverage
>> is limited. But recently found dm-mpath regressions should be
>> detectable
>> with this. I hope this helps people working on dm-multipath related
>> code
>> as a regression test set.
>>
>> Though this is created as a patch for linux kernel source, it's just
>> for
>> convenience of kernel developers (I don't have a place to host this
>> kind
>> of scripts). If there are better place to contribute this, please let
>> me know.
> 
> Have you considered placing it under tools/testing/selftests/? I think
> people are looking for testing there instead of Documentation.

Yes, but I think (the current contents of) my scripts don't fit well for
the purpose of 'tools/testing/selftests', which is a place for unit tests.
My scripts are for long-run stress testing and may need parameter
tuning depending on running environment.

Thanks for the comment.
-- 
Jun'ichi Nomura, NEC Corporation
