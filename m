From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 13/34] iscsi-target: add new transport type
Date: Tue, 1 Mar 2016 06:48:48 -0800
Message-ID: <20160301144848.GB9738@infradead.org>
References: <cover.1455467089.git.varun@chelsio.com>
 <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

This really looks like an odd interface.  I think everyone will
be much happpier in the long run if you do a generic offload interface
instead of special casing each possible driver.
