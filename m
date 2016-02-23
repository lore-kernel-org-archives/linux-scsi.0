From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Announce] sg3_utils-1.42 available
Date: Mon, 22 Feb 2016 17:05:44 -0800
Message-ID: <56CBB068.5060106@sandisk.com>
References: <56C54F9A.80902@interlog.com> <56C620E8.4040708@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0054.outbound.protection.outlook.com ([157.56.111.54]:34240
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756652AbcBWBGg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2016 20:06:36 -0500
In-Reply-To: <56C620E8.4040708@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>
Cc: Martin Pitt <mpitt@debian.org>, David Sommerseth <davids@redhat.com>, Hannes Reinecke <hare@suse.de>, Ritesh Raj Sarraf <rrs@researchut.com>, "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel <linux-kernel@vger.kernel.org>

On 02/18/2016 11:52 AM, Douglas Gilbert wrote:
> On 16-02-17 11:59 PM, Douglas Gilbert wrote:
>> sg3_utils is a package of command line utilities for sending
>> SCSI and some ATA commands to devices. This package targets
>> the Linux 4, 3, 2.6 and 2.4 kernel series. It has ports to
>> FreeBSD, Tru64, Solaris, and Windows (cygwin and MinGW).
>>
>> There are two new utilities (sg_read_attr and sg_timestamp)
>> and additions to many others, see the ChangeLog below. This
>> version tracks various changes made by www.t10.org since May
>> 2015 until January 2016.
>
> Missed the links:
> For an overview of sg3_utils and downloads see this page:
>      http://sg.danny.cz/sg/sg3_utils.html
> The sg_ses utility (for enclosure devices) is discussed at:
>      http://sg.danny.cz/sg/sg_ses.html
> A full changelog can be found at:
>      http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

Hi Doug,

Thanks for all the work you have done for maintaining sg3_utils and also 
for having prepared a new release. I have already downloaded version 
v1.42 and started using that version. The detailed changelog is helpful. 
However, I think for sg3_utils contributors it would be convenient to 
have access to the sg3_utils source code repository such that we can see 
all the patches that went in. Is such a repository publicly available, 
and if not, do you have any plans to make such a repository available ? 
Since I have a few patches ready that I would like to contribute to the 
sg3_utils package, is there a mailing list that I should CC when sending 
these patches to you ?

Thanks,

Bart.
