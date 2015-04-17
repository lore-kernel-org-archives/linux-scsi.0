From: Tejun Heo <tj@kernel.org>
Subject: Re: ahci Port to Host interrupt as edge trigger
Date: Fri, 17 Apr 2015 10:42:35 -0400
Message-ID: <20150417144235.GB1954@htj.duckdns.org>
References: <CAOHikRCrbKhchHM71KPUUxSw7107ZWpBCbmTHsSSqSbUdCLJyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOHikRCrbKhchHM71KPUUxSw7107ZWpBCbmTHsSSqSbUdCLJyg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 17, 2015 at 04:22:17PM +0530, Suman Tripathi wrote:
> Hi ,
> 
> I need some suggestion .
> 
> From the below interrupt handler in libahci.c it explains that the
> interrupt from port to Host is level  triggered. Do we have any
> existing implementation that handles the port to Host as Edge
> triggered.

Not that I know of but if it works as a edge triggered latch, would it
need anything done different?

-- 
tejun
