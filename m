From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros for accessing
	3-byte arrays as integers
Date: Wed, 10 Sep 2008 10:07:12 -0400
Message-ID: <20080910140712.GA12280@infradead.org>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752892AbYIJOHb@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080905165732.16689.50256.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Leech <christopher.leech@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devel@open-fcoe.org, jfs-discussion@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 05, 2008 at 09:57:32AM -0700, Chris Leech wrote:
> Both iSCSI and Fibre Channel make use of 24-bit big-endian values in
> frame headers.  This patch defines __be24 and __le24 typedefs for a
> structure wrapped around a 3-byte array, and macros to convert back and
> forth to a 32-bit integer.
> 
> The undefs in iscsi_proto.h are because of the different calling
> convention for the existing hton24 macro in the iSCSI code.  iSCSI will
> be converted in a subsequent patch.

JFS already defines an __le24, see fs/jfs/endian24.h.  Please try to
cover it, too or at least make sure you don't break it.
