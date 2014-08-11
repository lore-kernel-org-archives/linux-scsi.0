From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 6/18] arcmsr: precise checking adapter ID
Date: Mon, 11 Aug 2014 06:13:20 -0700
Message-ID: <20140811131320.GA23810@infradead.org>
References: <1407142512.4756.54.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1407142512.4756.54.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 04, 2014 at 04:55:12PM +0800, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
> 
> This patch rewrites the arcmsr_define_adapter_type function to precisely check Areca adapter's ID.
> This can prevent an unknown adapter being used as a default adapter type by driver.
> 
> Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> ---
> 
> Thanks for Christoph advice.

This still doesn't use the private_data field in the pci device table.
