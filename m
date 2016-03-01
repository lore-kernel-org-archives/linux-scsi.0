From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 23/34] iscsi-target: split iscsi_target_rx_thread()
Date: Tue, 1 Mar 2016 07:02:57 -0800
Message-ID: <20160301150257.GI9738@infradead.org>
References: <cover.1455467089.git.varun@chelsio.com>
 <494c1253bad50c0173f7869a2a8ede5dbe5ed7a5.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <494c1253bad50c0173f7869a2a8ede5dbe5ed7a5.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 14, 2016 at 11:15:30PM +0530, Varun Prakash wrote:
> split iscsi_target_rx_thread() into two parts,
> 1. iscsi_target_rx_thread() is common to all
>    transport drivers, it will call Rx function
>    registered by transport driver.
> 
> 2. iscsit_rx_pdu() is Rx function for
>    ISCSI_TCP transport.

It seems like the cleaner approach would be to have thread management
in the driver (or preferably workqueues!) and export a few helpers
for common code.
