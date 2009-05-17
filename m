From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH UPDATED block#for-2.6.31 2/3] block: set rq->resid_len
 to blk_rq_bytes() on issue
Date: Sun, 17 May 2009 20:41:18 +0900
Message-ID: <4A0FF7DE.7030303@gmail.com>
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <4A0E0650.1020500@gmail.com> <4A0FCF52.7070406@panasas.com> <4A0FF5EA.3020805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A0FF5EA.3020805@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov <petkovbb@googlemail.com>, Pete Zaitcev <zaitcev@redhat.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> I think I'll just add resid_len adjustment there right after
> __data_len manipulation.  That code path should really go away
> eventually.

Aieee... crap, I also forgot the merging path.  I'll change as you
suggested.  Thanks.

-- 
tejun
