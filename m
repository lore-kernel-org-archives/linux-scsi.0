From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET #upstream] libata: separate out SFF and BMDMA
Date: Tue, 28 Oct 2008 10:06:47 +0900
Message-ID: <490665A7.9050002@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org> <490619DF.6020804@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <490619DF.6020804@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> Tejun Heo wrote:
> ..
>> This patchset further separates SFF/BMDMA support from the rest of the
>> libata and separate out BMDMA from SFF.  This patchset contains the
>> following 22 patches.
> ..
> 
> Heh.. I wonder how this will fit with an upcoming task on my list:
> adding ATAPI support to sata_mv..
> 
> Currently sata_mv is a more-or-less purely FIS-based driver,
> with little need for SFF and no need for BMDMA.
> 
> But ATAPI on those chips uses BMDMA, as does target-mode (also on the
> list).
> It'll be interesting.

Nah... just move it to 'dependent on BMDMA' and inherit from
ata_bmdma_port_ops.  There are other drivers which do the same thing.

-- 
tejun
