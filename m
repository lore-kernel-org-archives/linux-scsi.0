From: "Martinez, Michael - CSREES/ISTM" <MMARTINEZ@intranet.reeusda.gov>
Subject: Anyone aware of known issues with the scsi driver in kernel-smp-2
	.4.2-2?
Date: Thu, 9 May 2002 09:20:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <630DA58AD01AD311B13A00C00D00E9BC05D20130@CSREESSERVER>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

I'm using kernel-smp-2.4.2-2, and I'm having some problems with my
scsi tape, which is a HP SureDat device; and using Sony DDS-3 DAT tapes.

Any sort of write and recover procedure (tar; dump; cat; dd) results in
random byte mistakes in the recovered data. These byte mistakes always
follow the form of being offset from the original byte, by 2.

For example, if the original byte had an octal value of 88; then the
recovered byte would be 90.

A file of 12kbytes would have on average five or six of these mistakes. 

Has anyone heard of an issue with the SCSI driver that would produce this
type of problem?


Michael Martinez
System Administrator
Research, Education and Extension Service
United States Department of Agriculture
Washington, DC
(202) 720-6223

