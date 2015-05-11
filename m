From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 3/5] Replace MAX_COMMAND_SIZE with BLK_MAX_CDB
Date: Mon, 11 May 2015 08:32:50 +0200
Message-ID: <20150511063250.GD30323@lst.de>
References: <554C6E79.7020501@sandisk.com> <554C6EFF.5000400@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <554C6EFF.5000400@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jbottomley@odin.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I know I suggested this, but as I have some other work to actually kill
BLK_MAX_CDB now we might want to go for the light-weight variant where
we just #define MAX_COMMAND_SIZE to BLK_MAX_CDB for now.

Sorry for causing this additional work.
