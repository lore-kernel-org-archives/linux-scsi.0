From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] qla2xxx: remove writeq/readq function definitions
Date: Fri, 2 Jun 2017 23:28:07 +0000
Message-ID: <1496446086.3881.1.camel@sandisk.com>
References: <20170602113225.24816-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170602113225.24816-1-clabbe.montjoie@gmail.com>
Content-Language: en-US
Content-ID: <53F06DC9D3BC4A4ABDBDC514CACBCB0F@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "clabbe.montjoie@gmail.com" <clabbe.montjoie@gmail.com>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-06-02 at 13:32 +0200, Corentin Labbe wrote:
> Instead of rewriting write/readq, use linux/io-64-nonatomic-lo-hi.h which
> already have them.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
