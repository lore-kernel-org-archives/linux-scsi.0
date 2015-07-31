From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/iscsi: fix digest computation for chained SGs
Date: Thu, 30 Jul 2015 23:27:11 -0700
Message-ID: <1438324031.16598.13.camel@haakon3.risingtidesystems.com>
References: <1437437534-17931-1-git-send-email-sbaugh@catern.com>
	 <55AE0995.2010209@dev.mellanox.co.il>
	 <CAL1RGDWAVnwD0bwdFyaUNofjMC6MWREn4pK_3Qu6ZV1rXzL9-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDWAVnwD0bwdFyaUNofjMC6MWREn4pK_3Qu6ZV1rXzL9-w@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Spencer Baugh <sbaugh@catern.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Andy Grover <agrover@redhat.com>, Christophe Vu-Brugier <cvubrugier@fastmail.fm>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Alexei Potashnik <alexei@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-07-21 at 18:38 -0700, Roland Dreier wrote:
> On Tue, Jul 21, 2015 at 1:57 AM, Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
> > How were you able to get a chained SG list in the target code?
> 
> Local hack.  So this bug can't be hit in current mainline code, but
> patch improves the code and removes a hidden booby-trap, so I think it
> makes sense to apply.
> --

Applied to target-pending/for-next.

Thanks Roland & Co.
