From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 15/34] iscsi-target: export symbols from iscsi_target.c
Date: Tue, 1 Mar 2016 06:49:48 -0800
Message-ID: <20160301144948.GD9738@infradead.org>
References: <cover.1455467089.git.varun@chelsio.com>
 <a52145ef75173d293b229cab3e3eba08528aefdc.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a52145ef75173d293b229cab3e3eba08528aefdc.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 14, 2016 at 11:12:09PM +0530, Varun Prakash wrote:
> export symbols from iscsi_target.c for
> ISCSI_TCP_CXGB4 transport driver.

What exactly is the reason for the split between this and the previous
patch?
