From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: mpt2sas logged messages
Date: Tue, 18 Aug 2009 13:47:51 -0400
Message-ID: <4A8AE947.5060403@redhat.com>
References: <660360F4F2570145BD872F298951B17AE303DB55@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32801 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759020AbZHRRqG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 13:46:06 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17AE303DB55@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, Tom Coughlan <coughlan@redhat.com>

On 08/18/2009 01:02 PM, Moore, Eric wrote:
> On Tuesday, August 18, 2009 10:13 AM,  James Bottomley wrote:
>>> The code (0x12) means PL_LOGINFO_CODE_ABORT
>>> The sub_code(0x102) means
>> PL_LOGINFO_SUB_CODE_OPEN_FAILURE_PATHWAY_BLOCKED
>>
>> To translate this according to the SAS 1.1 specification, a
>> pathway open
>> failed because a timeout fired before the path could be established.
>>
>> You can mitigate this by increasing the expander partial
>> pathway timeout
>> value. (or just move to a more efficient configuration).
>>
>
> I was telling Ric it was something else in seperate email.  The pathway was blocked due to two initiors establishing a connection to single port. That woudl be the case if he wasn't using a sata multiplexor.
>
>
> anyways, if the pathway timeout is the issue, then I believe you can set the pathway timeout value using Dougs smp tools, smp_phy_control , setting the --pptv command line option.
>
> http://sg.danny.cz/sg/smp_utils.html

Thanks, I will give that a try,

ric

