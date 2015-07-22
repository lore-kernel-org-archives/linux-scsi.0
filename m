From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH] target/iscsi: fix digest computation for chained SGs
Date: Tue, 21 Jul 2015 18:38:04 -0700
Message-ID: <CAL1RGDWAVnwD0bwdFyaUNofjMC6MWREn4pK_3Qu6ZV1rXzL9-w@mail.gmail.com>
References: <1437437534-17931-1-git-send-email-sbaugh@catern.com> <55AE0995.2010209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55AE0995.2010209@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Spencer Baugh <sbaugh@catern.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Andy Grover <agrover@redhat.com>, Christophe Vu-Brugier <cvubrugier@fastmail.fm>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Alexei Potashnik <alexei@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 21, 2015 at 1:57 AM, Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
> How were you able to get a chained SG list in the target code?

Local hack.  So this bug can't be hit in current mainline code, but
patch improves the code and removes a hidden booby-trap, so I think it
makes sense to apply.
