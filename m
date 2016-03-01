From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 22/34] iscsi-target: call Rx thread function
Date: Tue, 1 Mar 2016 07:01:37 -0800
Message-ID: <20160301150137.GH9738@infradead.org>
References: <cover.1455467089.git.varun@chelsio.com>
 <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 14, 2016 at 11:15:29PM +0530, Varun Prakash wrote:
> call Rx thread function if registered
> by transport driver, so that transport
> drivers can use iscsi-target Rx thread
> for Rx processing.
> 
> update iSER target driver to use this
> interface.

Not related to your new driver, but what's the point of even starting a
RX thread for iSER?
