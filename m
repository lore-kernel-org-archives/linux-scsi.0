From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Fri, 21 Apr 2017 21:20:23 +0000
Message-ID: <1492809623.2499.4.camel@sandisk.com>
References: <20170421211302.2667649-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22244 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1041465AbdDUVU1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 17:20:27 -0400
In-Reply-To: <20170421211302.2667649-1-songliubraving@fb.com>
Content-Language: en-US
Content-ID: <6264AB9F091AE84D85F5887D18187FE1@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "songliubraving@fb.com" <songliubraving@fb.com>
Cc: "hch@infradead.org" <hch@infradead.org>

On Fri, 2017-04-21 at 14:13 -0700, Song Liu wrote:
> On the other hand, some devices do long latency IO during deletion,
> for example, sd_shutdown() may do sync cache and/or start_stop.
> It is not necessary for these commands to run in series.

Have you noticed my patch series that makes sd_shutdown() submit the
SYNCHRONIZE CACHE command asynchronously? Have you tried whether that
patch series would be a good alternative?

Thanks,

Bart.=
