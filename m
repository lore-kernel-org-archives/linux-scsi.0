From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v1.0 10/16] arcmsr: clear outbound doorbell buffer
Date: Fri, 2 May 2014 11:51:48 +0300
Message-ID: <20140502085148.GE4963@mwanda>
References: <1398856765.6930.41.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1398856765.6930.41.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: ching <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 30, 2014 at 07:19:25PM +0800, ching wrote:
> From: Ching<ching2048@areca.com.tw>
> 
> Clearing outbound doorbell buffer completely for adapter type C.
> 

What are the user visible effects of this bug?

regards,
dan carpenter
