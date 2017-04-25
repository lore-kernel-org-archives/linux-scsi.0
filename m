From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 02/37] smartpqi: cleanup interrupt management
Date: Tue, 25 Apr 2017 19:54:49 +0000
Message-ID: <1493150087.2628.7.camel@sandisk.com>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314956402.13903.6707238397795732028.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:56494 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1433165AbdDYTyx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 15:54:53 -0400
In-Reply-To: <149314956402.13903.6707238397795732028.stgit@brunhilda>
Content-Language: en-US
Content-ID: <281260C30060DB408E84B359979725FB@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "Viswas.G@microsemi.com" <Viswas.G@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "Mahesh.Rajashekhara@microsemi.com" <Mahesh.Rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "Kevin.Barnett@microsemi.com" <Kevin.Barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Justin.Lindley@microsemi.com" <Justin.Lindley@microsemi.com>, "john.hall@microsemi.com" <john.hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-04-25 at 14:46 -0500, Don Brace wrote:
>  static int pqi_request_irqs(struct pqi_ctrl_info *ctrl_info)
>  {
> -	struct pci_dev *pdev =3D ctrl_info->pci_dev;
>  	int i;
>  	int rc;
> +	struct pci_dev *pdev =3D ctrl_info->pci_dev;

Was this change necessary? If not, please leave it out.

Thanks,

Bart.=
