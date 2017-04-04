From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] scsi: convert unrecovered read error to -EILSEQ
Date: Mon, 3 Apr 2017 23:57:19 -0700
Message-ID: <20170404065719.GB4614@infradead.org>
References: <1491221029-1609-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491221029-1609-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-block-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I'm planning to introduce new block-layer specific status code ASAP,
so I'd prefer not to add new errno special cases.

I'll port your patches to the new code and will send them out with
my series in a few days, though.
