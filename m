From: "conway, heather" <conway_heather@emc.com>
Subject: SCSI scanning issue with SuSE distributions?
Date: Mon, 26 Aug 2002 21:52:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <FA2F59D0E55B4B4892EA076FF8704F5501C1A439@srgraham.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "'suse-linux-e@suse.com'" <suse-linux-e@suse.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

> Hi Folks,
> I'm hoping you can help.  I'm working with SuSE attached to a CLARiiON
> array and the SuSE SCSI stack is incorrectly reporting CLARiiON devices.
> SuSE SLES 7, v7.3, and v8.0 all experience the same problem.  
> The problem is as follows:
> When a SuSE host is attached to the CLARiiON, it is inaccurately reporting
> that there are 254 devices per HBA.  For clarity's sake, I do not think
> that problem is that Linux doesn't support more than 128 devices....that
> isn't the problem here.  
> For instance, if a system has two HBAs with only 8 CLARiiON devices
> allocated to each HBA for a total of 16 actual devices, the SuSE
> distributions will report 254 devices per HBA.  The system should see only
> a total of 16 CLARiiON devices, but instead, it reports that it sees 508.
> This happens with the qla2x00.o and qla2200/qla2300.o drivers that are
> incorporated into the SuSE distributions as well as the 'EMC-approved'
> v4.47.16 qLogic driver and v4.20L Emulex driver.  
> RedHat doesn't have this problem when attached to CLARiiON arrays, but
> their SCSI scanning is definitely different.  I have put together a couple
> of patches, but so far haven't come up with the right combination to
> correct the problem.
> Has anyone seen this previously?  If so, do you have a patch to resolve
> the problem ?
> Thanks in advance for the assistance.
> Heather
> 
