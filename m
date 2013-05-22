From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 21:37:54 +0200
Message-ID: <519D1E92.7030505@redhat.com>
References: <20130522093249.GC3466@mtj.dyndns.org> <519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org> <519C9CBC.3050003@redhat.com> <20130522134134.GA15189@mtj.dyndns.org> <519CD234.40608@redhat.com> <20130522150335.GC2777@thunk.org> <519CE9FE.2030007@redhat.com> <yq1vc6b561q.fsf@sermon.lab.mkp.net> <519CF99E.6010804@redhat.com> <20130522181135.GC20848@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60260 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3EVTiE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 May 2013 15:38:04 -0400
In-Reply-To: <20130522181135.GC20848@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Il 22/05/2013 20:11, Theodore Ts'o ha scritto:
> On Wed, May 22, 2013 at 07:00:14PM +0200, Paolo Bonzini wrote:
>> You have hardware providers selling cloud services that want to run
>> their own custom backup services from within a VM, which entails having
>> vendor-specific commands run from within a VM.  Or you have people that
>> run clusters that are half-physical and half-virtual and want to use the
>> same /dev/disk/by-id paths in both cases; perhaps, with NPIV, they want
>> to use one zoning approach for both physical and virtual machines.
>> Someone else they want to backup to tapes from a VM (for example s390
>> people who just put everything in a VM, so the distinction of physical
>> and virtual makes no sense for them).  Some people use virtual machines
>> as sandboxes, and want to burn the ISOs from the same VMs where they
>> download the ISOs.  Some people have vendor utilities that only run
>> under Windows, and want to run them in a VM.
> 
> So is this hypothetical or do you have a real customer in mind?

All of these come from real customers.

> If it's not theoretical, how does the cloud service control who has
> access to the CD burner, and how are the disks loaded into the CD
> burner?

CD burning would be used in a VM that runs on your local workstation, so
the VM gets access to the CD burner under your desk.  There was also a
developer of a CD burning tool that wanted to test it inside BSD,
Solaris and Windows VMs; the idea is the same.

Paolo
