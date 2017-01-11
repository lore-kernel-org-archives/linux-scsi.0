From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LFS/MM TOPIC][LFS/MM ATTEND]: - Storage Stack and Driver Testing
 methodology.
Date: Wed, 11 Jan 2017 08:42:33 +0100
Message-ID: <6aa8ee3e-a74b-41c7-e2f8-aba0f8f4236c@suse.de>
References: <CO2PR04MB218427BF42159B20FB26F74186670@CO2PR04MB2184.namprd04.prod.outlook.com>
 <CO2PR04MB2184DB653C04FB620B41435486670@CO2PR04MB2184.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CO2PR04MB2184DB653C04FB620B41435486670@CO2PR04MB2184.namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/10/2017 11:40 PM, Chaitanya Kulkarni wrote:
> Resending it at as a plain text.
> 
> From: Chaitanya Kulkarni
> Sent: Tuesday, January 10, 2017 2:37 PM
> To: lsf-pc@lists.linux-foundation.org
> Cc: linux-fsdevel@vger.kernel.org; linux-block@vger.kernel.org; linux-nvme@lists.infradead.org; linux-scsi@vger.kernel.org; linux-ide@vger.kernel.org
> Subject: [LFS/MM TOPIC][LFS/MM ATTEND]: - Storage Stack and Driver Testing methodology.
>   
> 
> Hi Folks,
> 
> I would like to propose a general discussion on Storage stack and device driver testing.
> 
> Purpose:-
> -------------
> The main objective of this discussion is to address the need for 
> a Unified Test Automation Framework which can be used by different subsystems
> in the kernel in order to improve the overall development and stability
> of the storage stack.
> 
> For Example:- 
> From my previous experience, I've worked on the NVMe driver testing last year and we
> have developed simple unit test framework
>  (https://github.com/linux-nvme/nvme-cli/tree/master/tests). 
> In current implementation Upstream NVMe Driver supports following subsystems:-
> 1. PCI Host.
> 2. RDMA Target.
> 3. Fiber Channel Target (in progress).
> Today due to lack of centralized automated test framework NVMe Driver testing is 
> scattered and performed using the combination of various utilities like nvme-cli/tests, 
> nvmet-cli, shell scripts (git://git.infradead.org/nvme-fabrics.git nvmf-selftests) etc.
> 
> In order to improve overall driver stability with various subsystems, it will be beneficial
> to have a Unified Test Automation Framework (UTAF) which will centralize overall
> testing. 
> 
> This topic will allow developers from various subsystem engage in the discussion about 
> how to collaborate efficiently instead of having discussions on lengthy email threads.
> 
> Participants:-
> ------------------
> I'd like to invite developers from different subsystems to discuss an approach towards 
> a unified testing methodology for storage stack and device drivers belongs to 
> different subsystems.
> 
> Topics for Discussion:-
> ------------------------------
> As a part of discussion following are some of the key points which we can focus on:-
> 1. What are the common components of the kernel used by the various subsystems?
> 2. What are the potential target drivers which can benefit from this approach? 
>   (e.g. NVMe, NVMe Over Fabric, Open Channel Solid State Drives etc.)
> 3. What are the desired features that can be implemented in this Framework?
>   (code coverage, unit tests, stress testings, regression, generating Coccinelle reports etc.) 
> 4. Desirable Report generation mechanism?
> 5. Basic performance validation?
> 6. Whether QEMU can be used to emulate some of the H/W functionality to create a test 
>   platform? (Optional subsystem specific)
> 
> Some background about myself I'm Chaitanya Kulkarni, I worked as a team lead 
> which was responsible for delivering scalable multiplatform Automated Test 
> Framework for device drivers testing at HGST. It's been used for more than 1 year on 
> Linux/Windows for unit testing/regression/performance validation of the NVMe Linux and
> Windows driver successfully. I've also recently started contributing to the 
> 
> NVMe Host and NVMe over Fabrics Target driver.
> 
Oh, yes, please.
That's a discussion I'd like to have, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
