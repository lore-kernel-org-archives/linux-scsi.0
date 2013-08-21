From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] target/iscsi: Remove macros that contain typecasts
Date: Tue, 20 Aug 2013 23:28:19 -0700
Message-ID: <20130821062819.GC25506@infradead.org>
References: <1377046807-15860-1-git-send-email-agrover@redhat.com>
 <1377046807-15860-4-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1377046807-15860-4-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 20, 2013 at 06:00:05PM -0700, Andy Grover wrote:
> These just want to return a pointer instead of a value, but are otherwise
> the same.
> 
> ISCSI_TPG_LUN macro was unused.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
