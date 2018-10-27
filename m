From: Christoph Hellwig <hch@lst.de>
Subject: remove exofs and the T10 OSD code V2
Date: Sat, 27 Oct 2018 10:20:17 +0200
Message-ID: <20181027082019.20838-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ooo@electrozaur.com, martin.petersen@oracle.com
Cc: Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The only real user of the T10 OSD protocol, the pNFS object layout
driver never went to the point of having shipping products, and we
removed it 1.5 years ago.  Exofs is just a simple example without
real life users.

The code has been mostly unmaintained for years and is getting in the
way of block / SCSI changes, so I think it's finally time to drop it.

Quote from Boaz:

"As I said then. It is used in Universities for studies and experiments.
Every once in a while. I get an email with questions and reports.

But yes feel free to remove the all thing!!

I guess I can put it up on github. In a public tree.

Just that I will need to forward port it myself, til now you guys
been doing this for me ;-)"
