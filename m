From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5]  arcmsr: Re-name the HBA Type
Date: Thu, 15 Nov 2012 06:11:59 -0800
Message-ID: <1352988719.2578.5.camel@dabdike>
References: <85E5FCE3D4AD4A2D9A3DE6E64060AF05@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <85E5FCE3D4AD4A2D9A3DE6E64060AF05@arecaaebe11fae>
Sender: linux-kernel-owner@vger.kernel.org
To: NickCheng <nick.cheng@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-11-15 at 15:24 +0800, NickCheng wrote:
> From: Nick Cheng <nick.cheng@areca.com.tw>
> 
> Replace the nameing, hba, hbb and hbc, with hbaA, hbaB abd hbaC respectively
> Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw

I can apply this with manual fixups because of the double // in the
diff:

> diff -uprN a//drivers/scsi/arcmsr/arcmsr_attr.c b//drivers/scsi/arcmsr/arcmsr_attr.c
> --- a//drivers/scsi/arcmsr/arcmsr_attr.c        2012-10-11 17:45:19.397738033 +0800
> +++ b//drivers/scsi/arcmsr/arcmsr_attr.c        2012-10-12 16:22:28.147962534 +0800

But come on, Nick, please, you can do better than this:  checkpatch.pl
is incredibly unhappy (please fix):

ERROR: trailing whitespace
#51: FILE: drivers/scsi/arcmsr/arcmsr.h:66:
+#define ARCMSR_CDB_SG_PAGE_LENGTH^I^I256 $

ERROR: Macros with complex values should be enclosed in parenthesis
#72: FILE: drivers/scsi/arcmsr/arcmsr.h:82:
+#define dma_addr_hi32(addr)			(uint32_t) ((addr>>16)>>16)

ERROR: Macros with complex values should be enclosed in parenthesis
#73: FILE: drivers/scsi/arcmsr/arcmsr.h:83:
+#define dma_addr_lo32(addr)			(uint32_t) (addr & 0xffffffff)

WARNING: please, no spaces at the start of a line
#82: FILE: drivers/scsi/arcmsr/arcmsr.h:92:
+      uint8_t Signature[8];$

ERROR: Macros with complex values should be enclosed in parenthesis
#119: FILE: drivers/scsi/arcmsr/arcmsr.h:125:
+#define ARCMSR_MESSAGE_READ_RQBUFFER		\
 	ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER

ERROR: Macros with complex values should be enclosed in parenthesis
#122: FILE: drivers/scsi/arcmsr/arcmsr.h:127:
+#define ARCMSR_MESSAGE_WRITE_WQBUFFER	\
 	ARECA_SATA_RAID | FUNCTION_WRITE_WQBUFFER

ERROR: Macros with complex values should be enclosed in parenthesis
#125: FILE: drivers/scsi/arcmsr/arcmsr.h:129:
+#define ARCMSR_MESSAGE_CLEAR_RQBUFFER	\
 	ARECA_SATA_RAID | FUNCTION_CLEAR_RQBUFFER

ERROR: Macros with complex values should be enclosed in parenthesis
#128: FILE: drivers/scsi/arcmsr/arcmsr.h:131:
+#define ARCMSR_MESSAGE_CLEAR_WQBUFFER	\
 	ARECA_SATA_RAID | FUNCTION_CLEAR_WQBUFFER

ERROR: Macros with complex values should be enclosed in parenthesis
#131: FILE: drivers/scsi/arcmsr/arcmsr.h:133:
+#define ARCMSR_MESSAGE_CLEAR_ALLQBUFFER	\
 	ARECA_SATA_RAID | FUNCTION_CLEAR_ALLQBUFFER

ERROR: Macros with complex values should be enclosed in parenthesis
#134: FILE: drivers/scsi/arcmsr/arcmsr.h:135:
+#define ARCMSR_MESSAGE_RETURN_CODE_3F	\
 	ARECA_SATA_RAID | FUNCTION_RETURN_CODE_3F

ERROR: Macros with complex values should be enclosed in parenthesis
#137: FILE: drivers/scsi/arcmsr/arcmsr.h:137:
+#define ARCMSR_MESSAGE_SAY_HELLO		\
 	ARECA_SATA_RAID | FUNCTION_SAY_HELLO

ERROR: Macros with complex values should be enclosed in parenthesis
#140: FILE: drivers/scsi/arcmsr/arcmsr.h:139:
+#define ARCMSR_MESSAGE_SAY_GOODBYE		\
 	ARECA_SATA_RAID | FUNCTION_SAY_GOODBYE

ERROR: Macros with complex values should be enclosed in parenthesis
#143: FILE: drivers/scsi/arcmsr/arcmsr.h:141:
+#define ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE	\
 	ARECA_SATA_RAID | FUNCTION_FLUSH_ADAPTER_CACHE

ERROR: trailing whitespace
#217: FILE: drivers/scsi/arcmsr/arcmsr.h:194:
+^Iuint32_t cfgPicStatus;^I/*30, 120-123*/^I$

ERROR: open brace '{' following struct go on the same line
#651: FILE: drivers/scsi/arcmsr/arcmsr.h:429:
+struct MessageUnit_C
+{

ERROR: trailing whitespace
#871: FILE: drivers/scsi/arcmsr/arcmsr.h:588:
+^Iuint32_t firm_cfg_version;^I$

ERROR: open brace '{' following struct go on the same line
#909: FILE: drivers/scsi/arcmsr/arcmsr.h:608:
+struct CommandControlBlock
+{

ERROR: trailing whitespace
#921: FILE: drivers/scsi/arcmsr/arcmsr.h:620:
+^I#define CCB_FLAG_MASTER_ABORTED^I0x0008^I$

ERROR: code indent should use tabs where possible
#1006: FILE: drivers/scsi/arcmsr/arcmsr.h:674:
+ ^I|ARCMSR_MU_OUTBOUND_MESSAGE1_INT^I\$

WARNING: please, no space before tabs
#1006: FILE: drivers/scsi/arcmsr/arcmsr.h:674:
+ ^I|ARCMSR_MU_OUTBOUND_MESSAGE1_INT^I\$

WARNING: please, no spaces at the start of a line
#1006: FILE: drivers/scsi/arcmsr/arcmsr.h:674:
+ ^I|ARCMSR_MU_OUTBOUND_MESSAGE1_INT^I\$

ERROR: space required after that ',' (ctx:VxV)
#1088: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:119:
+	struct device *dev = container_of(kobj,struct device, kobj);
 	                                      ^

ERROR: space required after that ',' (ctx:VxV)
#1401: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:194:
+		acb->pmuA = ioremap(pci_resource_start(pdev,0),
 		                                           ^

ERROR: space required after that ',' (ctx:VxV)
#1402: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:195:
+			pci_resource_len(pdev,0));
 			                     ^

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#1405: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:197:
+			printk(KERN_NOTICE "arcmsr%d: memory mapping"

WARNING: quoted string split across lines
#1406: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:198:
+			printk(KERN_NOTICE "arcmsr%d: memory mapping"
+				"region fail\n", acb->host->host_no);

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#1419: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:208:
+			printk(KERN_NOTICE "arcmsr%d: memory mapping"

WARNING: quoted string split across lines
#1420: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:209:
+			printk(KERN_NOTICE "arcmsr%d: memory mapping"
+				"region fail\n", acb->host->host_no);

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#1429: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:216:
+			printk(KERN_NOTICE "arcmsr%d: memory mapping"

WARNING: quoted string split across lines
#1430: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:217:
+			printk(KERN_NOTICE "arcmsr%d: memory mapping"
+				"region fail\n", acb->host->host_no);

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#1444: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:228:
+			printk(KERN_NOTICE "arcmsr%d: memory mapping"

WARNING: quoted string split across lines
#1445: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:229:
+			printk(KERN_NOTICE "arcmsr%d: memory mapping"
+				"region fail\n", acb->host->host_no);

WARNING: suspect code indent for conditional statements (16, 16)
#1450: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:232:
+		if (readl(&acb->pmuC->outbound_doorbell) &
[...]
+		writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,

WARNING: suspect code indent for conditional statements (16, 16)
#1535: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:369:
 		if (readl(&phbcmu->outbound_doorbell)
[...]
+		writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#1566: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:391:
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter"

WARNING: quoted string split across lines
#1567: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:392:
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter"
+			" cache' timeout, retry count down = %d \n",

WARNING: unnecessary whitespace before a quoted newline
#1567: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:392:
+			" cache' timeout, retry count down = %d \n",

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#1588: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:409:
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter"

WARNING: quoted string split across lines
#1589: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:410:
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter"
+			" cache' timeout, retry count down = %d \n",

WARNING: unnecessary whitespace before a quoted newline
#1589: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:410:
+			" cache' timeout, retry count down = %d \n",

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#1615: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:430:
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter"

WARNING: quoted string split across lines
#1616: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:431:
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter"
+			" cache' timeout, retry count down = %d \n",

WARNING: unnecessary whitespace before a quoted newline
#1616: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:431:
+			" cache' timeout, retry count down = %d \n",

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#1675: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:491:
+		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error\n",

ERROR: trailing whitespace
#1710: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:520:
+arcmsr_message_isr_bh_fn(struct work_struct *work) $

ERROR: "(foo*)" should be "(foo *)"
#1746: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:528:
+		uint32_t __iomem *signature = (uint32_t __iomem*)

ERROR: "(foo*)" should be "(foo *)"
#1748: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:530:
+		char __iomem *devicemap = (char __iomem*)

ERROR: need consistent spacing around '-' (ctx:WxV)
#1756: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:538:
+			for (target = 0; target < ARCMSR_MAX_TARGETID -1;
 			                                              ^

ERROR: spaces required around that '=' (ctx:WxO)
#1762: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:544:
+					temp =*acb_dev_map;
 					     ^

ERROR: space required before that '*' (ctx:OxV)
#1762: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:544:
+					temp =*acb_dev_map;
 					      ^

WARNING: Too many leading tabs - consider code refactoring
#1765: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:547:
+						if ((temp & 0x01) == 1 &&

WARNING: suspect code indent for conditional statements (48, 48)
#1765: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:547:
+						if ((temp & 0x01) == 1 &&
[...]
+						scsi_add_device(acb->host,

WARNING: Too many leading tabs - consider code refactoring
#1769: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:551:
+						} else if ((temp & 0x01) == 0

WARNING: Too many leading tabs - consider code refactoring
#1774: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:556:
+							if (psdev != NULL ) {

WARNING: suspect code indent for conditional statements (56, 56)
#1774: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:556:
+							if (psdev != NULL ) {
+							scsi_remove_device(psdev);

ERROR: space prohibited before that close parenthesis ')'
#1774: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:556:
+							if (psdev != NULL ) {

WARNING: line over 80 characters
#1775: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:557:
+							scsi_remove_device(psdev);

ERROR: "(foo*)" should be "(foo *)"
#1825: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:576:
+			(uint32_t __iomem*)(&reg->message_rwbuffer[0]);

ERROR: "(foo*)" should be "(foo *)"
#1827: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:578:
+			(char __iomem*)(&reg->message_rwbuffer[21]);

ERROR: space required before the open parenthesis '('
#1834: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:585:
+			for(target = 0; target <

ERROR: need consistent spacing around '-' (ctx:WxV)
#1835: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:586:
+			ARCMSR_MAX_TARGETID -1; target++) {
 			                    ^

WARNING: line over 80 characters
#1841: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:592:
+					for (lun = 0; lun < ARCMSR_MAX_TARGETLUN;

WARNING: Too many leading tabs - consider code refactoring
#1843: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:594:
+						if ((temp & 0x01)==1 &&

WARNING: suspect code indent for conditional statements (48, 48)
#1843: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:594:
+						if ((temp & 0x01)==1 &&
[...]
+						scsi_add_device(acb->host,

ERROR: spaces required around that '==' (ctx:VxV)
#1843: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:594:
+						if ((temp & 0x01)==1 &&
 						                 ^

WARNING: Too many leading tabs - consider code refactoring
#1847: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:598:
+						} else if ((temp & 0x01) == 0

WARNING: suspect code indent for conditional statements (48, 48)
#1847: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:598:
+						} else if ((temp & 0x01) == 0
[...]
+						psdev = scsi_device_lookup(acb->host,

WARNING: line over 80 characters
#1849: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:600:
+						psdev = scsi_device_lookup(acb->host,

WARNING: Too many leading tabs - consider code refactoring
#1851: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:602:
+							if (psdev != NULL) {

WARNING: suspect code indent for conditional statements (56, 56)
#1851: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:602:
+							if (psdev != NULL) {
+							scsi_remove_device(psdev);

WARNING: line over 80 characters
#1852: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:603:
+							scsi_remove_device(psdev);

WARNING: Too many leading tabs - consider code refactoring
#1920: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:640:
+						if ((temp & 0x01) == 1 &&

WARNING: suspect code indent for conditional statements (48, 48)
#1920: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:640:
+						if ((temp & 0x01) == 1 &&
[...]
+						scsi_add_device(acb->host,

WARNING: Too many leading tabs - consider code refactoring
#1924: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:644:
+						} else if ((temp & 0x01) == 0

WARNING: suspect code indent for conditional statements (48, 48)
#1924: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:644:
+						} else if ((temp & 0x01) == 0
[...]
+						psdev = scsi_device_lookup(acb->host,

WARNING: line over 80 characters
#1926: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:646:
+						psdev = scsi_device_lookup(acb->host,

WARNING: Too many leading tabs - consider code refactoring
#1928: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:648:
+							if (psdev != NULL) {

WARNING: suspect code indent for conditional statements (56, 56)
#1928: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:648:
+							if (psdev != NULL) {
+							scsi_remove_device(psdev);

WARNING: line over 80 characters
#1929: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:649:
+							scsi_remove_device(psdev);

WARNING: braces {} are not necessary for single statement blocks
#1955: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:672:
+	if (error) {
 		return -ENODEV;
 	}

WARNING: braces {} are not necessary for single statement blocks
#1962: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:677:
+	if (!host) {
     		goto pci_disable_dev;
 	}

WARNING: braces {} are not necessary for single statement blocks
#1992: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:707:
+	if (error) {
 		goto scsi_host_release;
 	}

WARNING: braces {} are not necessary for single statement blocks
#2001: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:719:
+	if (!error) {
 		goto pci_release_regs;
 	}

WARNING: braces {} are not necessary for single statement blocks
#2006: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:723:
+	if (!error) {
 		goto unmap_pci_region;
 	}

WARNING: braces {} are not necessary for single statement blocks
#2011: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:727:
+	if (error) {
 		goto free_hbb_mu;
 	}

WARNING: braces {} are not necessary for single statement blocks
#2017: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:732:
+	if (error) {
 		goto RAID_controller_stop;
 	}

WARNING: braces {} are not necessary for single statement blocks
#2024: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:737:
+	if (error) {
 		goto scsi_host_remove;
 	}

WARNING: unnecessary whitespace before a quoted newline
#2066: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:785:
+		"arcmsr%d: wait 'abort all outstanding command' timeout \n"

WARNING: unnecessary whitespace before a quoted newline
#2087: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:801:
+		"arcmsr%d: wait 'abort all outstanding command' timeout \n"

WARNING: unnecessary whitespace before a quoted newline
#2105: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:815:
+		"arcmsr%d: wait 'abort all outstanding command' timeout \n"

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then
pr_err(...  to printk(KERN_ERR ...
#2148: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:850:
+		printk(KERN_ERR "arcmsr%d: can't set driver mode.\n",

ERROR: trailing whitespace
#2237: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:932:
+arcmsr_report_ccb_state(struct AdapterControlBlock *acb, $

WARNING: unnecessary whitespace before a quoted newline
#2264: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:971:
+			" error done, but got unknown DeviceStatus = 0x%x \n"

WARNING: line over 80 characters
#2279: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:985:
+arcmsr_drain_donequeue(struct AdapterControlBlock *acb, struct
CommandControlBlock *pCCB, bool error)

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#2292: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:996:
+				printk(KERN_NOTICE "arcmsr%d: pCCB ='0x%p' isr"

WARNING: quoted string split across lines
#2293: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:997:
+				printk(KERN_NOTICE "arcmsr%d: pCCB ='0x%p' isr"
+				"got aborted command \n",

WARNING: unnecessary whitespace before a quoted newline
#2293: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:997:
+				"got aborted command \n",

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#2300: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1002:
+		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command"

WARNING: quoted string split across lines
#2301: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1003:
+		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command"
+				"done acb = '0x%p'"

WARNING: unnecessary whitespace before a quoted newline
#2303: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1005:
 				" ccboutstandingcount = %d \n"

ERROR: space required before the open parenthesis '('
#2326: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1034:
+		while(((flag_ccb = readl(&reg->outbound_queueport))

WARNING: unnecessary whitespace before a quoted newline
#2638: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1346:
+		"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"

WARNING: braces {} are not necessary for single statement blocks
#3051: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1727:
+	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT)) {
 		return 1;
 	}

WARNING: braces {} are not necessary for single statement blocks
#3057: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1731:
+	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT) {
+		arcmsr_hbaA_doorbell_isr(acb);
 	}

WARNING: braces {} are not necessary for single statement blocks
#3153: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1805:
+		if (arcmsr_hbaA_handle_isr(acb)) {
 			return IRQ_NONE;
 		}

WARNING: braces {} are not necessary for single statement blocks
#3161: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1812:
+		if (arcmsr_hbaB_handle_isr(acb)) {
 			return IRQ_NONE;
 		}

WARNING: braces {} are not necessary for single statement blocks
#3168: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1818:
+		if (arcmsr_hbaC_handle_isr(acb)) {
 			return IRQ_NONE;
 		}

ERROR: space prohibited before that close parenthesis ')'
#3220: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1880:
+	(uint32_t ) cmd->cmnd[6] << 16 |

ERROR: space prohibited before that close parenthesis ')'
#3221: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1881:
+	(uint32_t ) cmd->cmnd[7] << 8  |

ERROR: space prohibited before that close parenthesis ')'
#3222: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1882:
+	(uint32_t ) cmd->cmnd[8];

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#3538: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2277:
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware"

WARNING: quoted string split across lines
#3539: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2278:
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware"
+			"miscellaneous data' timeout\n",

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#3570: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2305:
+	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s"

WARNING: quoted string split across lines
#3571: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2306:
+	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s"
+		"& Model %s\n",

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#3601: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2340:
+		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent"

WARNING: quoted string split across lines
#3602: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2341:
+		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent"
+		" got error for hbb mu\n", acb->host->host_no);

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#3648: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2374:
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware"

WARNING: quoted string split across lines
#3649: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2375:
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware"
+		"miscellaneous data' timeout \n", acb->host->host_no);

WARNING: unnecessary whitespace before a quoted newline
#3649: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2375:
+		"miscellaneous data' timeout \n", acb->host->host_no);

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#3680: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2401:
+	printk(KERN_NOTICE "Areca RAID Controller%d:"

WARNING: quoted string split across lines
#3681: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2402:
+	printk(KERN_NOTICE "Areca RAID Controller%d:"
+		"F/W %s & Model %s\n",

WARNING: suspect code indent for conditional statements (16, 16)
#3727: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2445:
+		if (readl(&reg->outbound_doorbell) &
[...]
+		writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#3738: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2454:
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware"

WARNING: quoted string split across lines
#3739: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2455:
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware"
+		"miscellaneous data' timeout \n", pACB->host->host_no);

WARNING: unnecessary whitespace before a quoted newline
#3739: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2455:
+		"miscellaneous data' timeout \n", pACB->host->host_no);

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#3756: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2472:
+	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s &"

WARNING: quoted string split across lines
#3757: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2473:
+	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s &"
+	"Model %s\n",

ERROR: do not use assignment in if condition
#3808: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2514:
+		if ((flag_ccb = readl(&reg->outbound_queueport)) ==

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#3841: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2536:
+				printk(KERN_NOTICE "arcmsr%d: scsi id = %d"

WARNING: quoted string split across lines
#3842: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2537:
+				printk(KERN_NOTICE "arcmsr%d: scsi id = %d"
+				" lun = %d ccb = '0x%p' poll command"

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#3858: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2547:
+			printk(KERN_NOTICE "arcmsr%d: polling get an illegal"

WARNING: quoted string split across lines
#3859: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2548:
+			printk(KERN_NOTICE "arcmsr%d: polling get an illegal"
+			 "ccb command done ccb = '0x%p'"

WARNING: unnecessary whitespace before a quoted newline
#3860: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2549:
+			"ccboutstandingcount = %d \n"

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#3930: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2609:
+				printk(KERN_NOTICE "arcmsr%d:"

WARNING: quoted string split across lines
#3931: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2610:
+				printk(KERN_NOTICE "arcmsr%d:"
+				" scsi id = %d lun = %d ccb = '0x%p' poll"

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#3943: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2620:
+			printk(KERN_NOTICE "arcmsr%d: polling get an"

WARNING: quoted string split across lines
#3944: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2621:
+			printk(KERN_NOTICE "arcmsr%d: polling get an"
+				"illegal ccb command done ccb = '0x%p'"

WARNING: unnecessary whitespace before a quoted newline
#3945: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2622:
 				"ccboutstandingcount = %d \n"

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#4000: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2674:
+				printk(KERN_NOTICE "arcmsr%d:"

WARNING: quoted string split across lines
#4001: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2675:
+				printk(KERN_NOTICE "arcmsr%d:"
+				" scsi id = %d lun = %d ccb = '0x%p' poll"

WARNING: unnecessary whitespace before a quoted newline
#4002: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2676:
+				"command abort successfully \n"

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#4017: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2685:
+			printk(KERN_NOTICE "arcmsr%d: polling get an illegal"

WARNING: quoted string split across lines
#4018: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2686:
+			printk(KERN_NOTICE "arcmsr%d: polling get an illegal"
+			 "ccb command done ccb = '0x%p'"

WARNING: unnecessary whitespace before a quoted newline
#4019: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2687:
+			"ccboutstandingcount = %d \n"

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#4083: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2756:
+				printk(KERN_NOTICE "arcmsr%d: set ccb"

WARNING: quoted string split across lines
#4084: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2757:
+				printk(KERN_NOTICE "arcmsr%d: set ccb"
+				"high part physical address timeout\n",

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#4099: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2778:
+			printk(KERN_NOTICE

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#4115: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2797:
+			printk(KERN_NOTICE

WARNING: unnecessary whitespace before a quoted newline
#4117: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2799:
+			"timeout \n", acb->host->host_no);

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#4138: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2810:
+			printk(KERN_NOTICE

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#4150: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2822:
+				printk(KERN_NOTICE "arcmsr%d: 'set"

WARNING: quoted string split across lines
#4151: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2823:
+				printk(KERN_NOTICE "arcmsr%d: 'set"
+				" command Q window' timeout \n",

WARNING: unnecessary whitespace before a quoted newline
#4151: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2823:
+				" command Q window' timeout \n",

ERROR: space prohibited before that close parenthesis ')'
#4205: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2871:
+		((acb->acb_flags & ACB_F_BUS_RESET) != 0 )

ERROR: space prohibited before that close parenthesis ')'
#4206: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2872:
+		|| ((acb->acb_flags & ACB_F_ABORT) != 0 )) {

ERROR: space prohibited before that close parenthesis ')'
#4244: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2902:
+		((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) ||

ERROR: space prohibited before that close parenthesis ')'
#4245: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2903:
+		((acb->acb_flags & ACB_F_ABORT) != 0 )) {

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#4363: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2989:
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter"

WARNING: quoted string split across lines
#4364: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2990:
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter"
+		" background rebulid' timeout \n", acb->host->host_no);

WARNING: unnecessary whitespace before a quoted newline
#4364: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2990:
+		" background rebulid' timeout \n", acb->host->host_no);

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#4379: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3001:
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter"

WARNING: quoted string split across lines
#4380: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3002:
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter"
+		"backgroundrebulid' timeout \n", acb->host->host_no);

WARNING: unnecessary whitespace before a quoted newline
#4380: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3002:
+		"backgroundrebulid' timeout \n", acb->host->host_no);

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#4402: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3017:
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter"

WARNING: quoted string split across lines
#4403: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3018:
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter"
+		" background rebulid' timeout \n", pACB->host->host_no);

WARNING: unnecessary whitespace before a quoted newline
#4403: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3018:
+		" background rebulid' timeout \n", pACB->host->host_no);

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#4486: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3089:
+				printk(KERN_NOTICE "ARCMSR IOP"

WARNING: quoted string split across lines
#4487: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3090:
+				printk(KERN_NOTICE "ARCMSR IOP"
+				" enables EOI_MODE TIMEOUT");

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then
pr_notice(...  to printk(KERN_NOTICE ...
#4507: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3110:
+	printk(KERN_NOTICE "arcmsr%d: executing hw bus reset .....\n",

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then
pr_err(...  to printk(KERN_ERR ...
#4579: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3207:
+	printk(KERN_ERR "arcmsr: executing bus reset eh.....num_resets = %d,"

WARNING: quoted string split across lines
#4580: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3208:
+	printk(KERN_ERR "arcmsr: executing bus reset eh.....num_resets = %d,"
+	"num_aborts = %d \n", acb->num_resets, acb->num_aborts);

WARNING: unnecessary whitespace before a quoted newline
#4580: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3208:
+	"num_aborts = %d \n", acb->num_resets, acb->num_aborts);

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then
pr_err(...  to printk(KERN_ERR ...
#4596: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3215:
+			printk(KERN_ERR "arcmsr: there is an bus"

WARNING: quoted string split across lines
#4597: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3216:
+			printk(KERN_ERR "arcmsr: there is an bus"
+			" reset eh proceeding.......\n");

WARNING: braces {} are not necessary for single statement blocks
#4601: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3220:
+			if (timeout) {
+				return SUCCESS;
 			}

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then
pr_err(...  to printk(KERN_ERR ...
#4631: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3234:
+				printk(KERN_ERR "arcmsr%d: waiting for"

WARNING: quoted string split across lines
#4632: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3235:
+				printk(KERN_ERR "arcmsr%d: waiting for"
+				" hw bus reset return, retry=%d\n",

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then
pr_err(...  to printk(KERN_ERR ...
#4636: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3239:
+					printk(KERN_ERR "arcmsr%d: waiting"

WARNING: quoted string split across lines
#4637: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3240:
+					printk(KERN_ERR "arcmsr%d: waiting"
+					"for hw bus reset return,"

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then
pr_err(...  to printk(KERN_ERR ...
#4689: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3266:
+			printk(KERN_ERR "arcmsr: scsi bus reset eh"

WARNING: quoted string split across lines
#4690: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3267:
+			printk(KERN_ERR "arcmsr: scsi bus reset eh"
+			"returns with success\n");

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then
pr_err(...  to printk(KERN_ERR ...
#4743: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3298:
+			printk(KERN_ERR "arcmsr: there is an bus"

WARNING: quoted string split across lines
#4744: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3299:
+			printk(KERN_ERR "arcmsr: there is an bus"
+			"reset eh proceeding.......\n");

WARNING: braces {} are not necessary for single statement blocks
#4748: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3303:
+			if (timeout) {
+				return SUCCESS;
 			}

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then
pr_err(...  to printk(KERN_ERR ...
#4777: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3316:
+				printk(KERN_ERR "arcmsr%d: waiting"

WARNING: quoted string split across lines
#4778: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3317:
+				printk(KERN_ERR "arcmsr%d: waiting"
+				" for hw bus reset return, retry = %d\n",

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then
pr_err(...  to printk(KERN_ERR ...
#4782: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3321:
+					printk(KERN_ERR "arcmsr%d:"

WARNING: quoted string split across lines
#4783: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3322:
+					printk(KERN_ERR "arcmsr%d:"
+					"waiting for hw bus reset return,"

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then
pr_err(...  to printk(KERN_ERR ...
#4839: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3352:
+			printk(KERN_ERR "arcmsr: scsi bus reset"

WARNING: quoted string split across lines
#4840: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3353:
+			printk(KERN_ERR "arcmsr: scsi bus reset"
+			"eh returns with success\n");

ERROR: spaces required around that '=' (ctx:WxV)
#4872: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3381:
+	struct AdapterControlBlock *acb =(struct AdapterControlBlock *)
 	                                ^

WARNING: unnecessary whitespace before a quoted newline
#4880: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3387:
+		"scsi id = %d lun = %d \n",

total: 44 errors, 148 warnings, 4757 lines checked

James
