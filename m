From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH] scsi/isci/phy.c: Code tidiness, delete the redundant
 function call "sci_change_state(&iphy->sm, SCI_PHY_STOPPED)"
Date: Mon, 23 Sep 2013 14:56:01 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A5EF2B3@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54448 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab3IWO4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 10:56:37 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xinghai Yu <yuxinghai@cn.fujitsu.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>

On 07/19/2013 Xinghai Yu <yuxinghai@cn.fujitsu.com> wrote:
> The "sci_phy_link_layer_initialization()" was called only once in
> "sci_phy_initialize()" and it is called before a call of "sci_change_state(&iphy-
> >sm, SCI_PHY_STOPPED)". So the same call in the end of
> "sci_phy_link_layer_initialization()" is redundant.
> 
> Signed-off-by: Xinghai Yu <yuxinghai@cn.fujitsu.com>
> ---
>  drivers/scsi/isci/phy.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
> index cb87b2e..82e8491 100644
> --- a/drivers/scsi/isci/phy.c
> +++ b/drivers/scsi/isci/phy.c
> @@ -309,9 +309,6 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
>  	 */
>  	writel(0, &llr->link_layer_hang_detection_timeout);
> 
> -	/* We can exit the initial state to the stopped state */
> -	sci_change_state(&iphy->sm, SCI_PHY_STOPPED);
> -
>  	return SCI_SUCCESS;
>  }
> 

Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>

