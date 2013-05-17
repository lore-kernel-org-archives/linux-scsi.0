From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH 2/3] BusLogic: Coalesce formats with multiple string
 fragments
Date: Fri, 17 May 2013 14:19:06 -0600
Message-ID: <1368821946.24376.2.camel@concerto>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
	 <1fe580d1ae95bff774f2561837a22ea772733863.1368765873.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1fe580d1ae95bff774f2561837a22ea772733863.1368765873.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-05-16 at 21:58 -0700, Joe Perches wrote:
> Strings fragments coalesced by the compiler are
> difficult to grep.  Coalesce them instead.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/BusLogic.c | 66 ++++++++++++++++++++++++-------------------------
>  1 file changed, 33 insertions(+), 33 deletions(-)

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
