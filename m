From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] scsi: fix lockdep warning
Date: Tue, 30 Mar 2010 10:08:06 -0700
Message-ID: <4BB22FF6.5040003@kernel.org>
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com>	<86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com>	<m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org>	<m14okqnczd.fsf@fess.ebiederm.org> <4B99A6F0.4080203@kernel.org>	<4BA47692.7040401@kernel.org> <4bb21338.0d0db80a.1685.ffffb9e1@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:60588 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab0C3RJO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2010 13:09:14 -0400
In-Reply-To: <4bb21338.0d0db80a.1685.ffffb9e1@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <gregkh@suse.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On 03/30/2010 08:05 AM, Ben Gamari wrote:
> On Sat, 20 Mar 2010 00:17:38 -0700, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> with qlogic and emulex card etc.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
> 
> As several others have pointed out, you appear to be call sysfs_bin_attr_init()
> against statically allocated attributes. Is there an updated patchset that you've been meaning to send out?

not tracking it for while. it seems James had the same version in scsi-next 

> 
> Moreover, there are still failures in the ACPI thermal driver (at very least)
> on master (9623e5a23724d09283c238960946ec6f65733afe).

can you send out the trace?

Thanks

Yinghai
