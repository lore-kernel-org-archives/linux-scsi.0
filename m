From: akpm@linux-foundation.org
Subject: [patch 06/30] ips: trim trailing whitespace
Date: Thu, 13 Dec 2007 16:14:08 -0800
Message-ID: <200712140014.lBE0E84x026183@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36097 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763815AbXLNAR5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:17:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org, jgarzik@redhat.com, mark_salyzyn@adaptec.com

From: Jeff Garzik <jeff@garzik.org>

[akpm@linux-foundation.org: coding style fixes]
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c |   49 +++++++++++++++++++++----------------------
 drivers/scsi/ips.h |   12 +++++-----
 2 files changed, 31 insertions(+), 30 deletions(-)

diff -puN drivers/scsi/ips.c~ips-trim-trailing-whitespace drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~ips-trim-trailing-whitespace
+++ a/drivers/scsi/ips.c
@@ -389,17 +389,17 @@ static struct  pci_device_id  ips_pci_ta
 MODULE_DEVICE_TABLE( pci, ips_pci_table );
 
 static char ips_hot_plug_name[] = "ips";
-   
+
 static int __devinit  ips_insert_device(struct pci_dev *pci_dev, const struct pci_device_id *ent);
 static void __devexit ips_remove_device(struct pci_dev *pci_dev);
-   
+
 static struct pci_driver ips_pci_driver = {
 	.name		= ips_hot_plug_name,
 	.id_table	= ips_pci_table,
 	.probe		= ips_insert_device,
 	.remove		= __devexit_p(ips_remove_device),
 };
-           
+
 
 /*
  * Necessary forward function protoypes
@@ -587,7 +587,7 @@ static void
 ips_setup_funclist(ips_ha_t * ha)
 {
 
-	/*                                
+	/*
 	 * Setup Functions
 	 */
 	if (IPS_IS_MORPHEUS(ha) || IPS_IS_MARCO(ha)) {
@@ -2081,7 +2081,7 @@ ips_host_info(ips_ha_t * ha, char *ptr, 
     /* That keeps everything happy for "text" operations on the proc file.                    */
 
 	if (le32_to_cpu(ha->nvram->signature) == IPS_NVRAM_P5_SIG) {
-        if (ha->nvram->bios_low[3] == 0) { 
+	if (ha->nvram->bios_low[3] == 0) {
             copy_info(&info,
 			          "\tBIOS Version                      : %c%c%c%c%c%c%c\n",
 			          ha->nvram->bios_high[0], ha->nvram->bios_high[1],
@@ -2780,10 +2780,11 @@ ips_next(ips_ha_t * ha, int intr)
 		scb->dcdb.cmd_attribute =
 		    ips_command_direction[scb->scsi_cmd->cmnd[0]];
 
-        /* Allow a WRITE BUFFER Command to Have no Data */
-        /* This is Used by Tape Flash Utilites          */
-        if ((scb->scsi_cmd->cmnd[0] == WRITE_BUFFER) && (scb->data_len == 0)) 
-            scb->dcdb.cmd_attribute = 0;                  
+		/* Allow a WRITE BUFFER Command to Have no Data */
+		/* This is Used by Tape Flash Utilites          */
+		if ((scb->scsi_cmd->cmnd[0] == WRITE_BUFFER) &&
+				(scb->data_len == 0))
+			scb->dcdb.cmd_attribute = 0;
 
 		if (!(scb->dcdb.cmd_attribute & 0x3))
 			scb->dcdb.transfer_length = 0;
@@ -3404,7 +3405,7 @@ ips_map_status(ips_ha_t * ha, ips_scb_t 
 
 				/* Restrict access to physical DASD */
 				if (scb->scsi_cmd->cmnd[0] == INQUIRY) {
-				    ips_scmd_buf_read(scb->scsi_cmd, 
+				    ips_scmd_buf_read(scb->scsi_cmd,
                                       &inquiryData, sizeof (inquiryData));
  				    if ((inquiryData.DeviceType & 0x1f) == TYPE_DISK) {
 				        errcode = DID_TIME_OUT;
@@ -4090,10 +4091,10 @@ ips_chkstatus(ips_ha_t * ha, IPS_STATUS 
 			scb->scsi_cmd->result = errcode << 16;
 		} else {	/* bus == 0 */
 			/* restrict access to physical drives */
-			if (scb->scsi_cmd->cmnd[0] == INQUIRY) { 
-			    ips_scmd_buf_read(scb->scsi_cmd, 
+			if (scb->scsi_cmd->cmnd[0] == INQUIRY) {
+			    ips_scmd_buf_read(scb->scsi_cmd,
                                   &inquiryData, sizeof (inquiryData));
-			    if ((inquiryData.DeviceType & 0x1f) == TYPE_DISK) 
+			    if ((inquiryData.DeviceType & 0x1f) == TYPE_DISK)
 			        scb->scsi_cmd->result = DID_TIME_OUT << 16;
 			}
 		}		/* else */
@@ -4661,8 +4662,8 @@ ips_isinit_morpheus(ips_ha_t * ha)
 	uint32_t bits;
 
 	METHOD_TRACE("ips_is_init_morpheus", 1);
-   
-	if (ips_isintr_morpheus(ha)) 
+
+	if (ips_isintr_morpheus(ha))
 	    ips_flush_and_reset(ha);
 
 	post = readl(ha->mem_ptr + IPS_REG_I960_MSG0);
@@ -4686,7 +4687,7 @@ ips_isinit_morpheus(ips_ha_t * ha)
 /*   state ( was trying to INIT and an interrupt was already pending ) ...  */
 /*                                                                          */
 /****************************************************************************/
-static void 
+static void
 ips_flush_and_reset(ips_ha_t *ha)
 {
 	ips_scb_t *scb;
@@ -4718,9 +4719,9 @@ ips_flush_and_reset(ips_ha_t *ha)
 	    if (ret == IPS_SUCCESS) {
 	        time = 60 * IPS_ONE_SEC;	              /* Max Wait time is 60 seconds */
 	        done = 0;
-	            
+
 	        while ((time > 0) && (!done)) {
-	           done = ips_poll_for_flush_complete(ha); 	   
+		   done = ips_poll_for_flush_complete(ha);
 	           /* This may look evil, but it's only done during extremely rare start-up conditions ! */
 	           udelay(1000);
 	           time--;
@@ -4749,17 +4750,17 @@ static int
 ips_poll_for_flush_complete(ips_ha_t * ha)
 {
 	IPS_STATUS cstatus;
-    
+
 	while (TRUE) {
 	    cstatus.value = (*ha->func.statupd) (ha);
 
 	    if (cstatus.value == 0xffffffff)      /* If No Interrupt to process */
 			break;
-            
+
 	    /* Success is when we see the Flush Command ID */
-	    if (cstatus.fields.command_id == IPS_MAX_CMDS ) 
+	    if (cstatus.fields.command_id == IPS_MAX_CMDS)
 	        return 1;
-	 }	
+	 }
 
 	return 0;
 }
@@ -5920,7 +5921,7 @@ ips_read_config(ips_ha_t * ha, int intr)
 
 		return (0);
 	}
-	
+
 	memcpy(ha->conf, ha->ioctl_data, sizeof(*ha->conf));
 	return (1);
 }
@@ -5959,7 +5960,7 @@ ips_readwrite_page5(ips_ha_t * ha, int w
 	scb->cmd.nvram.buffer_addr = ha->ioctl_busaddr;
 	if (write)
 		memcpy(ha->ioctl_data, ha->nvram, sizeof(*ha->nvram));
-	
+
 	/* issue the command */
 	if (((ret =
 	      ips_send_wait(ha, scb, ips_cmd_timeout, intr)) == IPS_FAILURE)
diff -puN drivers/scsi/ips.h~ips-trim-trailing-whitespace drivers/scsi/ips.h
--- a/drivers/scsi/ips.h~ips-trim-trailing-whitespace
+++ a/drivers/scsi/ips.h
@@ -92,7 +92,7 @@
    #ifndef min
       #define min(x,y) ((x) < (y) ? x : y)
    #endif
-   
+
    #ifndef __iomem       /* For clean compiles in earlier kernels without __iomem annotations */
       #define __iomem
    #endif
@@ -171,7 +171,7 @@
    #define IPS_CMD_DOWNLOAD             0x20
    #define IPS_CMD_RW_BIOSFW            0x22
    #define IPS_CMD_GET_VERSION_INFO     0xC6
-   #define IPS_CMD_RESET_CHANNEL        0x1A  
+   #define IPS_CMD_RESET_CHANNEL        0x1A
 
    /*
     * Adapter Equates
@@ -458,7 +458,7 @@ typedef struct {
    uint32_t reserved3;
    uint32_t buffer_addr;
    uint32_t reserved4;
-} IPS_IOCTL_CMD, *PIPS_IOCTL_CMD; 
+} IPS_IOCTL_CMD, *PIPS_IOCTL_CMD;
 
 typedef struct {
    uint8_t  op_code;
@@ -552,7 +552,7 @@ typedef struct {
    uint32_t cccr;
 } IPS_NVRAM_CMD, *PIPS_NVRAM_CMD;
 
-typedef struct 
+typedef struct
 {
     uint8_t  op_code;
     uint8_t  command_id;
@@ -650,7 +650,7 @@ typedef struct {
    uint8_t   device_address;
    uint8_t   cmd_attribute;
    uint8_t   cdb_length;
-   uint8_t   reserved_for_LUN; 	 
+   uint8_t   reserved_for_LUN;
    uint32_t  transfer_length;
    uint32_t  buffer_pointer;
    uint16_t  sg_count;
@@ -790,7 +790,7 @@ typedef struct {
                                              /* SubSystem Parameter[4]      */
 #define  IPS_GET_VERSION_SUPPORT 0x00018000  /* Mask for Versioning Support */
 
-typedef struct 
+typedef struct
 {
    uint32_t  revision;
    uint8_t   bootBlkVersion[32];
_
