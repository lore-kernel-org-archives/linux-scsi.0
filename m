From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCHSET #upstream] libata: separate out SFF and BMDMA
Date: Mon, 27 Oct 2008 15:43:27 -0400
Message-ID: <490619DF.6020804@rtr.ca>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
..
> This patchset further separates SFF/BMDMA support from the rest of the
> libata and separate out BMDMA from SFF.  This patchset contains the
> following 22 patches.
..

Heh.. I wonder how this will fit with an upcoming task on my list:
adding ATAPI support to sata_mv..

Currently sata_mv is a more-or-less purely FIS-based driver,
with little need for SFF and no need for BMDMA.

But ATAPI on those chips uses BMDMA, as does target-mode (also on the list).
It'll be interesting.

Cheers
