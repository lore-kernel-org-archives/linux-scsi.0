From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH UPDATED2 block#for-2.6.31 2/3] block: set rq->resid_len
 to  blk_rq_bytes() on issue
Date: Tue, 19 May 2009 18:14:12 +0900
Message-ID: <4A127864.8090701@gmail.com>
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <4A0E0650.1020500@gmail.com> <4A0FFD7E.8050607@gmail.com> <20090518124919.GK4140@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090518124919.GK4140@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov <petkovbb@googlemail.com>, Pete Zaitcev <zaitcev@redhat.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Jens.

Jens Axboe wrote:
> Tejun, you have to stop replying with updated patches in an existing
> thread. It's virtually impossible to sort the resulting mess into
> patches worth applying.

Heh.. yeah, I usually post minor updates as UPDATED patches for review
then repost the whole series after accumulating some of them.  This
patchset's size was on the borderline for proper patchset and I was
feeling lazy.  Sorry about that.  Will repost.

Thanks.

-- 
tejun
