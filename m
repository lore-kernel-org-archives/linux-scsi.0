From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v1.3 2/18] arcmsr: Add code to support MSI-X, MSI
 interrupt
Date: Fri, 1 Aug 2014 13:49:13 +0300
Message-ID: <20140801104913.GM4804@mwanda>
References: <1406881989.10378.39.camel@Centos6.3-64>
 <20140801084616.GA26695@dhcp-26-207.brq.redhat.com>
 <1406889528.10378.145.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406889528.10378.145.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: Alexander Gordeev <agordeev@redhat.com>, hch@infradead.org, jbottomley@parallels.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 01, 2014 at 06:38:48PM +0800, Ching Huang wrote:
> Hi Alexander,
> 
> Thanks for your advice.
> This patch was revised according to your comment.
> 
> Signed-off-by: Ching<ching2048@areca.com.tw>

This patch is something that can't be applied at all.  There is no
changelog.  Apply the patch with `cat email.txt | git am` and review
the changelog using the `git log` command.

https://www.google.com/search?q=how+to+send+a+v2+patch

Also the Signed-off-by line is wrong.  It should have your full name.
There needs to be a space between the name and the email address.

regards,
dan carpenter
