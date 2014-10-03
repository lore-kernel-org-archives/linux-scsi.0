From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv5 00/24] scsi logging update (the boring part)
Date: Fri, 03 Oct 2014 09:08:24 +0200
Message-ID: <542E4B68.2000200@suse.de>
References: <1412144580-72880-1-git-send-email-hare@suse.de> <94D0CD8314A33A4D9D801C0FE68B402958CCABD2@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbaJCHI1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Oct 2014 03:08:27 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CCABD2@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/02/2014 08:53 PM, Elliott, Robert (Server Storage) wrote:
>
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Wednesday, 01 October, 2014 1:23 AM
>> To: James Bottomley
>> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Elliott, Robert (=
Server
>> Storage); Hannes Reinecke
>> Subject: [PATCHv5 00/24] scsi logging update (the boring part)
>>
>> This is the next iteration of my scsi logging patchset.
>> The patchset just contains some logging updates, code
>> reshuffling and sanity fixes. Nothing major.
>>
>> The second part of this patchset (the printk bit)
>> has been vetoed for the moment, so I'll have to
>> work on that. But in any case this patchset is
>> pretty much independent.
>>
>> Difference to v4:
>> - Add 'Reviewed-by' tags from hch where applicable
>> - Split off the fas216 patch into two different patches
>> - Added a patch to document scsi_try_to_abort_cmd
>>
>> Hannes Reinecke (24):
>>    Remove scsi_cmd_print_sense_hdr()
>>    sd: Remove scsi_print_sense() in sd_done()
>>    aha152x: Debug output update and whitespace cleanup
>>    scsi: introduce sdev_prefix_printk()
>>    scsi: Use sdev as argument for sense code printing
>>    acornscsi: use scsi_print_command()
>>    fas216: Return DID_ERROR for incomplete data transfer
>>    fas216: Update logging messages
>>    53c700: remove scsi_print_sense() usage
>>    scsi: stop decoding if scsi_normalize_sense() fails
>>    scsi: do not decode sense extras
>>    scsi: use 'bool' as return value for scsi_normalize_sense()
>>    scsi: remove scsi_print_status()
>>    Implement scsi_opcode_sa_name
>>    scsi: merge print_opcode_name()
>>    scsi: consolidate opcode lookup in scsi_opcode_sa_name()
>>    scsi: remove last argument from print_opcode_name()
>>    scsi: Remove scsi_print_command when calling abort
>>    scsi: separate out scsi_(host|driver)byte_string()
>>    sd: Cleanup logging
>>    scsi: simplify scsi_log_(send|completion)
>>    scsi: fixup logging messages in scsi_error.c
>>    scsi: use shost argument in scsi_eh_prt_fail_stats
>>    scsi_error: document scsi_try_to_abort_cmd
>
> With this 24-part series applied to 3.17rc7, with the
> kernel set to print timestamps (e.g., printk.time=3Dy on the kernel
> command line), the prints still end up trickling out a byte
> at a time, interleaved from different threads, when the system
> is overloaded.
>
> Maybe that's addressed by the part that is deferred?
>
Yes, unfortunately. I just wanted to get the main bulk of
patches in now so that I can concentrate on the real issue
and don't have to carry around tons of patches.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
