From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Anyone aware of known issues with the scsi driver in kernel-smp-2
Date: Thu, 9 May 2002 15:56:18 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E175pL8-0003sx-00@the-village.bc.nu>
References: <630DA58AD01AD311B13A00C00D00E9BC05D20130@CSREESSERVER>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <630DA58AD01AD311B13A00C00D00E9BC05D20130@CSREESSERVER> from "Martinez, Michael - CSREES/ISTM" at May 09, 2002 09:20:43 AM
List-Id: linux-scsi@vger.kernel.org
To: "Martinez, Michael - CSREES/ISTM" <MMARTINEZ@intranet.reeusda.gov>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

> Any sort of write and recover procedure (tar; dump; cat; dd) results in
> random byte mistakes in the recovered data. These byte mistakes always
> follow the form of being offset from the original byte, by 2.

Make sure scsi parity is enabled on the device. Make sure the cabling is
within specification and the termination good.

Alan
