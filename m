From: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] vsprintf: Remove support for %pF and %pf in favour of
 %pS and %ps
Date: Mon, 25 Mar 2019 10:49:01 +0100
Message-ID: <CAJZ5v0ixukjWzSUqNCOpYuQci=7+ctdEhdZwOh=afz1b2zFVaw@mail.gmail.com>
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <20190322132108.25501-3-sakari.ailus@linux.intel.com>
 <CAJZ5v0i8JiQGk25yZKQqTzCCY+nrfoKXOH8nM6eNPhkN-i+y9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAJZ5v0i8JiQGk25yZKQqTzCCY+nrfoKXOH8nM6eNPhkN-i+y9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:TARGET SUBSYSTEM" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux PM <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mmc <linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ACPI Devel Maling List <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux PCI <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 25, 2019 at 10:30 AM Rafael J. Wysocki <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Fri, Mar 22, 2019 at 2:21 PM Sakari Ailus
> <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> >
> > %pS and %ps are now the preferred conversion specifiers to print function
> > %names. The functionality is equivalent; remove the old, deprecated %pF
> > %and %pf support.
>
> Are %pF and %pf really not used any more in the kernel?
>
> If that is not the case, you need to convert the remaining users of
> them to using %ps or %pS before making support for them go away
> completely.

Well, this is a [2/2] in a series, sorry for the noise (/me blames
gmail for the confusion).
