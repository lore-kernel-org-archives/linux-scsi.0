From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2 3/4] Introduce XEN scsiback module
Date: Sat, 26 Jul 2014 08:23:58 -0700
Message-ID: <20140726152358.GA1854@infradead.org>
References: <1406288253-13293-1-git-send-email-jgross@suse.com>
 <1406288253-13293-4-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406288253-13293-4-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: jgross@suse.com
Cc: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, target-devel@vger.kernel.org, konrad.wilk@oracle.com
List-Id: linux-scsi@vger.kernel.org

Just a quick glance:

 a) this should move to drivers/target with the other target code
 b) you're still having your own CDB emulation in there, the target code
    should be taking care of all that.
