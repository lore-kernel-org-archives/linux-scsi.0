From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: Re: [PATCH][v3.18.y][3.19.y-ckt][4.0.y] storvsc: Set the SRB flags
 correctly when no data transfer is, needed
Date: Fri, 05 Jun 2015 13:59:24 -0400
Message-ID: <5571E37C.1070900@canonical.com>
References: <5571E19C.9000202@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <5571E19C.9000202@canonical.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: sasha.levin@oracle.com, Luis Henriques <luis.henriques@canonical.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: linux-scsi@vger.kernel.org, JBottomley@Odin.com, alexng@microsoft.com, LKML <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, devel@linuxdriverproject.org, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On 06/05/2015 01:51 PM, Joseph Salisbury wrote:
> Hello,
>     
> Please consider including mainline commit
> dc45708ca9988656d706940df5fd102672c5de92 in the next v3.18.y, v4.0.y and
> 3.19.y-ckt stable releases.  It was
> included in the mainline tree as of v4.1-rc5.  It has been tested and
> confirmed to resolve the following bug:
> http://bugs.launchpad.net/bugs/1439780
>  
> commit dc45708ca9988656d706940df5fd102672c5de92
> Author: K. Y. Srinivasan <kys@microsoft.com>
> Date:   Fri May 1 11:03:02 2015 -0700
>
>     storvsc: Set the SRB flags correctly when no data transfer is needed
>
>
>
> Sincerely,
>
> Joseph Salisbury
>
>
It looks like this commit was already cc'd to stable.  Sorry for the noise.

Thanks,

Joe
