From: Andy Grover <agrover@redhat.com>
Subject: Re: rtsadmin-v1.99 BETA packages
Date: Sat, 14 May 2011 16:36:53 -0700
Message-ID: <4DCF1215.2010406@redhat.com>
References: <1304121705.14278.196.camel@haakon2.linux-iscsi.org>	 <1304553788.10072.241.camel@haakon2.linux-iscsi.org>	 <4DCAC075.5090007@redhat.com>	 <1305160226.19744.47.camel@haakon2.linux-iscsi.org> <1305337311.7102.88.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab1ENXhc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 May 2011 19:37:32 -0400
In-Reply-To: <1305337311.7102.88.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@risingtidesystems.com
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Patil, Kiran" <kiran.patil@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jerome Martin <jxm@risingtidesystems.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>, Stefan Hajnoczi <stefanha@gmail.com>, linux-iscsi-target-dev <linux-iscsi-target-dev@googlegroups.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Paolo Bonzini <pbonzini@redhat.com>Jerome Martin <jxm@risingtidesystems.com>

On 05/13/2011 06:41 PM, Nicholas A. Bellinger wrote:
> This afternoon's updated RHEL6 and Debian Squeeze BETA builds are
> available here:
> 
> http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/rtsadmin-frozen-11.99-20110513091048.3434628.x86_64.rpm
> http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/rtsadmin-frozen_11.99-20110513161709.3434628_amd64.deb
> 
> These contain an important bugfix for v2 device creation where 
> /sys/kernel/config/target/core/$HBA/$DEV/wwn/vpd_unit_serial
> was not being automatically generated for newly created virtual devices.
> There is also a seperate multi-fabric export HBA context 'delete
> $DEVICE_NAME' that has been fixed as well and pushed into the community
> repo.
> 
> Also, the lio-utils v4.0 packages for RHEL6 and Debian Squeeze have been
> updated with a few minor improvements to tcm_fabric.py code.
> 
> http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/lio-utils-4.0-d2cf595d.x86_64.rpm
> http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/lio-utils_4.0_amd64.deb
> 
> Please let us know if you have any questions.

Hi nab and Jerome,

Could you explain the versioning of the rtsadmin-frozen packages? I
think the 2011.. is a datetime stamp, but I don't grok the 11.99 and
3434628.

Would it be possible to release src rpms/debs, or even a tar.gz, for
these as well?

Have you looked into putting these into yum or apt repos, for easy
upgrading?

Finally, I notice modified versions of the rpm specfiles I authored are
now in your rtsadmin[1], rtslib, and configshell repos. There is no
indication of origin or attribution to me or my employer. I think this
is technically ok since the files are licensed under the Fedora CLA[2],
but it is an accepted FOSS practice to say where you got something, at
least in the checkin notes.

I'm not sweating it, just letting you know :-)

But, this becomes a more significant issue when talking about code
contributions, and a potential non-free version of, or code that builds
on, rtsadmin. Once you accept outside contributions under the AGPLv3,
you are required to release the source of derivative works[3]. Could you
be a little clearer about your plans for a non-free version, and what
the boundary will be between it and the released code, so that we can
make contributions that do not end up in non-free code?

Thanks -- Regards -- Andy

[1]
http://www.risingtidesystems.com/git/?p=rtsadmin.git;a=commit;h=d9c8421c3df0f9a6b922903ba90df43068d687fa
[2] http://fedoraproject.org/wiki/Licensing#License_of_Fedora_SPEC_Files
[3] IANAL - I am not a lawyer.
