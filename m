From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: remove exofs and the T10 OSD code V2
Date: Wed, 31 Oct 2018 10:29:39 -0700
Message-ID: <1541006979.196084.138.camel@acm.org>
References: <20181027082019.20838-1-hch@lst.de>
         <c9740eeb-6b96-35b6-a436-7537669da1a9@electrozaur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c9740eeb-6b96-35b6-a436-7537669da1a9@electrozaur.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>, Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc: Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-10-31 at 18:34 +-0200, Boaz Harrosh wrote:
+AD4 On 27/10/18 11:20, Christoph Hellwig wrote:
+AD4 +AD4 The only real user of the T10 OSD protocol, the pNFS object layout
+AD4 +AD4 driver never went to the point of having shipping products, and we
+AD4 +AD4 removed it 1.5 years ago.  Exofs is just a simple example without
+AD4 +AD4 real life users.
+AD4 +AD4 
+AD4 +AD4 The code has been mostly unmaintained for years and is getting in the
+AD4 +AD4 way of block / SCSI changes, so I think it's finally time to drop it.
+AD4 +AD4 
+AD4 +AD4 Quote from Boaz:
+AD4 +AD4 
+AD4 +AD4 +ACI-As I said then. It is used in Universities for studies and experiments.
+AD4 +AD4 Every once in a while. I get an email with questions and reports.
+AD4 +AD4 
+AD4 +AD4 But yes feel free to remove the all thing+ACEAIQ
+AD4 
+AD4 I think I'm changing my mind about this.
+AD4 +AFs ... +AF0

The osd driver was accepted in the upstream kernel in 2009. I have checked all
commits in Linus' tree for the osd driver that went in since 2009. All changes
made by other kernel developers than you are the result of tree-wide refactoring,
compiler warning fixes, fixes for issues detected by static source code
analyzers or spelling fixes. Hence my question: how big is the user base of the
exofs and osd kernel drivers? 

Thanks,

Bart.
