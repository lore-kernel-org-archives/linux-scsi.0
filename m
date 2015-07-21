From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: fix memory leak with scsi-mq
Date: Tue, 21 Jul 2015 07:28:52 -0700
Message-ID: <20150721142852.GA13912@infradead.org>
References: <55A7D079.9010706@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55A7D079.9010706@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <JBottomley@Odin.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thanks Tony,

this looks good to me.  In the long run I'll see how we can hide
these implementation details in the lib/scatterlist.c code instead
of burdening it on the users.

Reviewed-by: Christoph Hellwig <hch@lst.de>
