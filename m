From: Christoph Hellwig <hch@infradead.org>
Subject: verbose argument to sd_synchronize_cache
Date: Sun, 27 Oct 2002 16:28:11 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027162811.A21987@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

sd_synchronize_cache() is always called with verbose=1, so this argument
should go away.  But do we really want to be that verbose here?  IMHO
we should remove the argumet and the printks..
