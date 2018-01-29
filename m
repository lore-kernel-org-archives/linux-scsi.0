From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 19/19] lpfc: Update modified files for 2018 Copyright
Date: Mon, 29 Jan 2018 09:35:16 +0100
Message-ID: <b39ac3cc-df92-81e6-dac9-463b84b61fec@suse.de>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
 <20180124224548.9530-20-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54067 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751296AbeA2KX7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 05:23:59 -0500
In-Reply-To: <20180124224548.9530-20-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 01/24/2018 11:45 PM, James Smart wrote:
> Updated Copyright in files updated 11.4.0.7
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h           | 2 +-
>  drivers/scsi/lpfc/lpfc_attr.c      | 2 +-
>  drivers/scsi/lpfc/lpfc_crtn.h      | 2 +-
>  drivers/scsi/lpfc/lpfc_els.c       | 2 +-
>  drivers/scsi/lpfc/lpfc_hbadisc.c   | 2 +-
>  drivers/scsi/lpfc/lpfc_hw4.h       | 2 +-
>  drivers/scsi/lpfc/lpfc_init.c      | 2 +-
>  drivers/scsi/lpfc/lpfc_mbox.c      | 2 +-
>  drivers/scsi/lpfc/lpfc_mem.c       | 2 +-
>  drivers/scsi/lpfc/lpfc_nportdisc.c | 4 ++--
>  drivers/scsi/lpfc/lpfc_nvme.c      | 2 +-
>  drivers/scsi/lpfc/lpfc_nvmet.c     | 2 +-
>  drivers/scsi/lpfc/lpfc_nvmet.h     | 2 +-
>  drivers/scsi/lpfc/lpfc_scsi.c      | 2 +-
>  drivers/scsi/lpfc/lpfc_sli.c       | 3 +--
>  drivers/scsi/lpfc/lpfc_sli4.h      | 2 +-
>  drivers/scsi/lpfc/lpfc_version.h   | 2 +-
>  17 files changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index d042f9118e3b..9698b9635058 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index b79dad7b8278..70bd25666243 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
> index 3ecf50df93f4..14a86b5b51e4 100644
> --- a/drivers/scsi/lpfc/lpfc_crtn.h
> +++ b/drivers/scsi/lpfc/lpfc_crtn.h
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 404e1af5e2ab..ba896554a14f 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 9265906d956e..f5bbac3cadbb 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
> index 52fe28ae50fa..8685d26e6929 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 895b1da784ee..04a77c308836 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
> index c32d4a323db2..7313ceb0f23b 100644
> --- a/drivers/scsi/lpfc/lpfc_mbox.c
> +++ b/drivers/scsi/lpfc/lpfc_mbox.c
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
> index 60078e61da5e..41361662ff08 100644
> --- a/drivers/scsi/lpfc/lpfc_mem.c
> +++ b/drivers/scsi/lpfc/lpfc_mem.c
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2014 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
> index bbf1e1342b09..b63179d895e2 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -1,7 +1,7 @@
> - /*******************************************************************
> +/*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index fc6d85f0bfcf..527e63c1f1ac 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
> index f8863c51ba20..5b9f456a9f5e 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channsel Host Bus Adapters.                               *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
> index 5da35de5ea45..c1bcef3f103c 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.h
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.h
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 10c2dc0cf1fa..c595046a521b 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index d597e15a1974..e97d080e9f65 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -1,8 +1,7 @@
> -
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
> index ac81bfa59278..4545c1fdcb55 100644
> --- a/drivers/scsi/lpfc/lpfc_sli4.h
> +++ b/drivers/scsi/lpfc/lpfc_sli4.h
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
> index 6f4092cb903e..3b04ecb17a38 100644
> --- a/drivers/scsi/lpfc/lpfc_version.h
> +++ b/drivers/scsi/lpfc/lpfc_version.h
> @@ -1,7 +1,7 @@
>  /*******************************************************************
>   * This file is part of the Emulex Linux Device Driver for         *
>   * Fibre Channel Host Bus Adapters.                                *
> - * Copyright (C) 2017 Broadcom. All Rights Reserved. The term      *
> + * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
>   * “Broadcom” refers to Broadcom Limited and/or its subsidiaries.  *
>   * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
>   * EMULEX and SLI are trademarks of Emulex.                        *
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
