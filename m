From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Sun, 11 Nov 2018 05:14:45 -0800
Message-ID: <20181111131445.GB25441@infradead.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

I think this goes in the wrong way.  There isn't really any point
in filtering at all if we have access to the whole device by the
file persmissions, and we generally should not allow any access for
partitions.

I think we need to simplify the selection, not add crazy amounts of
special case code.
