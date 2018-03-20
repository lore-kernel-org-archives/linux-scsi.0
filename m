From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] mpt3sas: Cache enclosure pages during enclosure add.
Date: Wed, 21 Mar 2018 05:06:52 +0800
Message-ID: <201803210419.5Ewwdskh%fengguang.wu@intel.com>
References: <1521540956-42347-1-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1521540956-42347-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Bart.VanAssche@wdc.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Hi Chaitra,

I love your patch! Perhaps something to improve:

[auto build test WARNING on v4.16-rc4]
[also build test WARNING on next-20180320]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Chaitra-P-B/mpt3sas-Cache-enclosure-pages-during-enclosure-add/20180320-220411
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:6100:63: sparse: incorrect type in argument 2 (different base types) @@    expected unsigned short [unsigned] [usertype] handle @@    got restriunsigned short [unsigned] [usertype] handle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6100:63:    expected unsigned short [unsigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6100:63:    got restricted __le16 [addressable] [usertype] EnclosureHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6907:13: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:6907:13: sparse: cast from restricted __le32
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:160:22: sparse: symbol 'mpt3sas_raid_template' was not declared. Should it be static?
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:161:22: sparse: symbol 'mpt2sas_raid_template' was not declared. Should it be static?
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:1373:24: sparse: symbol 'mpt3sas_scsih_enclosure_find_by_handle' was not declared. Should it be static?
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3749:36: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] handle @@    got  short [unsigned] [usertype] handle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3749:36:    expected unsigned short [unsigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3749:36:    got restricted __le16 [usertype] DevHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3942:9: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3949:28: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] Event @@    got unsignedrestricted __le16 [usertype] Event @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3949:28:    expected restricted __le16 [usertype] Event
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3949:28:    got unsigned short [unsigned] [usertype] event
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3950:35: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] EventContext @@    got unsignrestricted __le32 [usertype] EventContext @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3950:35:    expected restricted __le32 [usertype] EventContext
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:3950:35:    got unsigned int [unsigned] [usertype] event_context
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:4001:9: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:4009:32: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] DevHandle @@    got unsignedrestricted __le16 [usertype] DevHandle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:4009:32:    expected restricted __le16 [usertype] DevHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:4009:32:    got unsigned short [unsigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:4531:61: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] PrimaryReferenceTag @@    got restricted __le32 [usertype] PrimaryReferenceTag @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:4531:61:    expected restricted __le32 [usertype] PrimaryReferenceTag
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:4531:61:    got restricted __be32 [usertype] <noident>
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:7324:37: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] EnclosureHandle @@    got unsignedrestricted __le16 [usertype] EnclosureHandle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:7324:37:    expected restricted __le16 [usertype] EnclosureHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:7324:37:    got unsigned short [unsigned] [usertype] <noident>
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:7329:59: sparse: incorrect type in argument 2 (different base types) @@    expected unsigned short [unsigned] [usertype] handle @@    got  short [unsigned] [usertype] handle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:7329:59:    expected unsigned short [unsigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:7329:59:    got restricted __le16 [usertype] EnclosureHandle
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:7345:43: sparse: incorrect type in argument 5 (different base types) @@    expected unsigned int [unsigned] [usertype] handle @@    got ed int [unsigned] [usertype] handle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:7345:43:    expected unsigned int [unsigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:7345:43:    got restricted __le16 [usertype] EnclosureHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8408:55: sparse: incorrect type in argument 2 (different base types) @@    expected unsigned short [unsigned] [usertype] handle @@    got  short [unsigned] [usertype] handle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8408:55:    expected unsigned short [unsigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8408:55:    got restricted __le16 [usertype] EnclosureHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8416:63: sparse: restricted __le64 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8417:60: sparse: restricted __le16 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8441:43: sparse: restricted __le16 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8466:65: sparse: restricted __le16 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8470:44: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] handle @@    got  short [unsigned] [usertype] handle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8470:44:    expected unsigned short [unsigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8470:44:    got restricted __le16 [usertype] DevHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8472:62: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] handle @@    got  short [unsigned] [usertype] handle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8472:62:    expected unsigned short [unsigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8472:62:    got restricted __le16 [usertype] DevHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8558:51: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [addressable] [usertype] DevHandle @@    got cted __le16 [addressable] [usertype] DevHandle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8558:51:    expected restricted __le16 [addressable] [usertype] DevHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8558:51:    got unsigned short [unsigned] [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8563:43: sparse: incorrect type in assignment (different base types) @@    expected restricted __le64 [addressable] [usertype] SASAddress @@    got stricted __le64 [addressable] [usertype] SASAddress @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8563:43:    expected restricted __le64 [addressable] [usertype] SASAddress
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8563:43:    got unsigned long long [unsigned] [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8565:37: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [addressable] [usertype] Slot @@    got cted __le16 [addressable] [usertype] Slot @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8565:37:    expected restricted __le16 [addressable] [usertype] Slot
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8565:37:    got unsigned short [unsigned] [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8566:38: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [addressable] [usertype] Flags @@    got cted __le16 [addressable] [usertype] Flags @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8566:38:    expected restricted __le16 [addressable] [usertype] Flags
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8566:38:    got unsigned short [unsigned] [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8596:58: sparse: restricted __le64 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8597:58: sparse: restricted __le16 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8632:67: sparse: restricted __le16 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8636:45: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] handle @@    got  short [unsigned] [usertype] handle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8636:45:    expected unsigned short [unsigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8636:45:    got restricted __le16 [usertype] DevHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8638:62: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] handle @@    got  short [unsigned] [usertype] handle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8638:62:    expected unsigned short [unsigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8638:62:    got restricted __le16 [usertype] DevHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8688:38: sparse: incorrect type in assignment (different base types) @@    expected restricted __le64 [addressable] [usertype] WWID @@    got stricted __le64 [addressable] [usertype] WWID @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8688:38:    expected restricted __le64 [addressable] [usertype] WWID
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8688:38:    got unsigned long long [unsigned] [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8689:38: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [addressable] [usertype] Slot @@    got cted __le16 [addressable] [usertype] Slot @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8689:38:    expected restricted __le16 [addressable] [usertype] Slot
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8689:38:    got unsigned short [unsigned] [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8690:39: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [addressable] [usertype] Flags @@    got ed __le32 [addressable] [usertype] Flags @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8690:39:    expected restricted __le32 [addressable] [usertype] Flags
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8690:39:    got unsigned int [unsigned] [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8691:43: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [addressable] [usertype] DevHandle @@    got unsigrestricted __le16 [addressable] [usertype] DevHandle @@
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8691:43:    expected restricted __le16 [addressable] [usertype] DevHandle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:8691:43:    got unsigned short [unsigned] [assigned] [usertype] handle
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:9610:25: sparse: cast to restricted __le32

Please review and possibly fold the followup patch.

vim +6100 drivers/scsi/mpt3sas/mpt3sas_scsih.c

f92363d12 Sreekanth Reddy          2012-11-30  6030  
f92363d12 Sreekanth Reddy          2012-11-30  6031  /**
f92363d12 Sreekanth Reddy          2012-11-30  6032   * _scsih_add_device -  creating sas device object
f92363d12 Sreekanth Reddy          2012-11-30  6033   * @ioc: per adapter object
f92363d12 Sreekanth Reddy          2012-11-30  6034   * @handle: sas device handle
f92363d12 Sreekanth Reddy          2012-11-30  6035   * @phy_num: phy number end device attached to
f92363d12 Sreekanth Reddy          2012-11-30  6036   * @is_pd: is this hidden raid component
f92363d12 Sreekanth Reddy          2012-11-30  6037   *
f92363d12 Sreekanth Reddy          2012-11-30  6038   * Creating end device object, stored in ioc->sas_device_list.
f92363d12 Sreekanth Reddy          2012-11-30  6039   *
f92363d12 Sreekanth Reddy          2012-11-30  6040   * Returns 0 for success, non-zero for failure.
f92363d12 Sreekanth Reddy          2012-11-30  6041   */
f92363d12 Sreekanth Reddy          2012-11-30  6042  static int
f92363d12 Sreekanth Reddy          2012-11-30  6043  _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
f92363d12 Sreekanth Reddy          2012-11-30  6044  	u8 is_pd)
f92363d12 Sreekanth Reddy          2012-11-30  6045  {
f92363d12 Sreekanth Reddy          2012-11-30  6046  	Mpi2ConfigReply_t mpi_reply;
f92363d12 Sreekanth Reddy          2012-11-30  6047  	Mpi2SasDevicePage0_t sas_device_pg0;
f92363d12 Sreekanth Reddy          2012-11-30  6048  	struct _sas_device *sas_device;
793a6223b Chaitra P B              2018-03-20  6049  	struct _enclosure_node *enclosure_dev = NULL;
f92363d12 Sreekanth Reddy          2012-11-30  6050  	u32 ioc_status;
f92363d12 Sreekanth Reddy          2012-11-30  6051  	u64 sas_address;
f92363d12 Sreekanth Reddy          2012-11-30  6052  	u32 device_info;
f92363d12 Sreekanth Reddy          2012-11-30  6053  
f92363d12 Sreekanth Reddy          2012-11-30  6054  	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
f92363d12 Sreekanth Reddy          2012-11-30  6055  	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
f92363d12 Sreekanth Reddy          2012-11-30  6056  		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
f92363d12 Sreekanth Reddy          2012-11-30  6057  		    ioc->name, __FILE__, __LINE__, __func__);
f92363d12 Sreekanth Reddy          2012-11-30  6058  		return -1;
f92363d12 Sreekanth Reddy          2012-11-30  6059  	}
f92363d12 Sreekanth Reddy          2012-11-30  6060  
f92363d12 Sreekanth Reddy          2012-11-30  6061  	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
f92363d12 Sreekanth Reddy          2012-11-30  6062  	    MPI2_IOCSTATUS_MASK;
f92363d12 Sreekanth Reddy          2012-11-30  6063  	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
f92363d12 Sreekanth Reddy          2012-11-30  6064  		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
f92363d12 Sreekanth Reddy          2012-11-30  6065  		    ioc->name, __FILE__, __LINE__, __func__);
f92363d12 Sreekanth Reddy          2012-11-30  6066  		return -1;
f92363d12 Sreekanth Reddy          2012-11-30  6067  	}
f92363d12 Sreekanth Reddy          2012-11-30  6068  
f92363d12 Sreekanth Reddy          2012-11-30  6069  	/* check if this is end device */
f92363d12 Sreekanth Reddy          2012-11-30  6070  	device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
f92363d12 Sreekanth Reddy          2012-11-30  6071  	if (!(_scsih_is_end_device(device_info)))
f92363d12 Sreekanth Reddy          2012-11-30  6072  		return -1;
c696f7b83 Suganath Prabu Subramani 2016-10-26  6073  	set_bit(handle, ioc->pend_os_device_add);
f92363d12 Sreekanth Reddy          2012-11-30  6074  	sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
f92363d12 Sreekanth Reddy          2012-11-30  6075  
f92363d12 Sreekanth Reddy          2012-11-30  6076  	/* check if device is present */
f92363d12 Sreekanth Reddy          2012-11-30  6077  	if (!(le16_to_cpu(sas_device_pg0.Flags) &
f92363d12 Sreekanth Reddy          2012-11-30  6078  	    MPI2_SAS_DEVICE0_FLAGS_DEVICE_PRESENT)) {
f92363d12 Sreekanth Reddy          2012-11-30  6079  		pr_err(MPT3SAS_FMT "device is not present handle(0x04%x)!!!\n",
f92363d12 Sreekanth Reddy          2012-11-30  6080  			ioc->name, handle);
f92363d12 Sreekanth Reddy          2012-11-30  6081  		return -1;
f92363d12 Sreekanth Reddy          2012-11-30  6082  	}
f92363d12 Sreekanth Reddy          2012-11-30  6083  
f92363d12 Sreekanth Reddy          2012-11-30  6084  	/* check if there were any issues with discovery */
f92363d12 Sreekanth Reddy          2012-11-30  6085  	if (_scsih_check_access_status(ioc, sas_address, handle,
f92363d12 Sreekanth Reddy          2012-11-30  6086  	    sas_device_pg0.AccessStatus))
f92363d12 Sreekanth Reddy          2012-11-30  6087  		return -1;
f92363d12 Sreekanth Reddy          2012-11-30  6088  
d1cb5e495 Sreekanth Reddy          2015-11-11  6089  	sas_device = mpt3sas_get_sdev_by_addr(ioc,
f92363d12 Sreekanth Reddy          2012-11-30  6090  					sas_address);
d1cb5e495 Sreekanth Reddy          2015-11-11  6091  	if (sas_device) {
c696f7b83 Suganath Prabu Subramani 2016-10-26  6092  		clear_bit(handle, ioc->pend_os_device_add);
d1cb5e495 Sreekanth Reddy          2015-11-11  6093  		sas_device_put(sas_device);
f92363d12 Sreekanth Reddy          2012-11-30  6094  		return -1;
d1cb5e495 Sreekanth Reddy          2015-11-11  6095  	}
f92363d12 Sreekanth Reddy          2012-11-30  6096  
758889564 Sreekanth Reddy          2017-10-10  6097  	if (sas_device_pg0.EnclosureHandle) {
793a6223b Chaitra P B              2018-03-20  6098  		enclosure_dev =
793a6223b Chaitra P B              2018-03-20  6099  			mpt3sas_scsih_enclosure_find_by_handle(ioc,
758889564 Sreekanth Reddy          2017-10-10 @6100  						sas_device_pg0.EnclosureHandle);
793a6223b Chaitra P B              2018-03-20  6101  		if (enclosure_dev == NULL)
793a6223b Chaitra P B              2018-03-20  6102  			pr_info(MPT3SAS_FMT "Enclosure handle(0x%04x)"
793a6223b Chaitra P B              2018-03-20  6103  			       "doesn't match with enclosure device!\n",
758889564 Sreekanth Reddy          2017-10-10  6104  			       ioc->name, sas_device_pg0.EnclosureHandle);
758889564 Sreekanth Reddy          2017-10-10  6105  	}
758889564 Sreekanth Reddy          2017-10-10  6106  
f92363d12 Sreekanth Reddy          2012-11-30  6107  	sas_device = kzalloc(sizeof(struct _sas_device),
f92363d12 Sreekanth Reddy          2012-11-30  6108  	    GFP_KERNEL);
f92363d12 Sreekanth Reddy          2012-11-30  6109  	if (!sas_device) {
f92363d12 Sreekanth Reddy          2012-11-30  6110  		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
f92363d12 Sreekanth Reddy          2012-11-30  6111  		    ioc->name, __FILE__, __LINE__, __func__);
f92363d12 Sreekanth Reddy          2012-11-30  6112  		return 0;
f92363d12 Sreekanth Reddy          2012-11-30  6113  	}
f92363d12 Sreekanth Reddy          2012-11-30  6114  
d1cb5e495 Sreekanth Reddy          2015-11-11  6115  	kref_init(&sas_device->refcount);
f92363d12 Sreekanth Reddy          2012-11-30  6116  	sas_device->handle = handle;
f92363d12 Sreekanth Reddy          2012-11-30  6117  	if (_scsih_get_sas_address(ioc,
f92363d12 Sreekanth Reddy          2012-11-30  6118  	    le16_to_cpu(sas_device_pg0.ParentDevHandle),
f92363d12 Sreekanth Reddy          2012-11-30  6119  	    &sas_device->sas_address_parent) != 0)
f92363d12 Sreekanth Reddy          2012-11-30  6120  		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
f92363d12 Sreekanth Reddy          2012-11-30  6121  		    ioc->name, __FILE__, __LINE__, __func__);
f92363d12 Sreekanth Reddy          2012-11-30  6122  	sas_device->enclosure_handle =
f92363d12 Sreekanth Reddy          2012-11-30  6123  	    le16_to_cpu(sas_device_pg0.EnclosureHandle);
e6d45e3e7 Sreekanth Reddy          2015-06-30  6124  	if (sas_device->enclosure_handle != 0)
f92363d12 Sreekanth Reddy          2012-11-30  6125  		sas_device->slot =
f92363d12 Sreekanth Reddy          2012-11-30  6126  		    le16_to_cpu(sas_device_pg0.Slot);
f92363d12 Sreekanth Reddy          2012-11-30  6127  	sas_device->device_info = device_info;
f92363d12 Sreekanth Reddy          2012-11-30  6128  	sas_device->sas_address = sas_address;
f92363d12 Sreekanth Reddy          2012-11-30  6129  	sas_device->phy = sas_device_pg0.PhyNum;
f92363d12 Sreekanth Reddy          2012-11-30  6130  	sas_device->fast_path = (le16_to_cpu(sas_device_pg0.Flags) &
f92363d12 Sreekanth Reddy          2012-11-30  6131  	    MPI25_SAS_DEVICE0_FLAGS_FAST_PATH_CAPABLE) ? 1 : 0;
f92363d12 Sreekanth Reddy          2012-11-30  6132  
aa53bb895 Suganath Prabu Subramani 2016-10-26  6133  	if (le16_to_cpu(sas_device_pg0.Flags)
aa53bb895 Suganath Prabu Subramani 2016-10-26  6134  		& MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
e6d45e3e7 Sreekanth Reddy          2015-06-30  6135  		sas_device->enclosure_level =
aa53bb895 Suganath Prabu Subramani 2016-10-26  6136  			sas_device_pg0.EnclosureLevel;
310c8e40d Calvin Owens             2016-07-27  6137  		memcpy(sas_device->connector_name,
310c8e40d Calvin Owens             2016-07-27  6138  			sas_device_pg0.ConnectorName, 4);
310c8e40d Calvin Owens             2016-07-27  6139  		sas_device->connector_name[4] = '\0';
e6d45e3e7 Sreekanth Reddy          2015-06-30  6140  	} else {
e6d45e3e7 Sreekanth Reddy          2015-06-30  6141  		sas_device->enclosure_level = 0;
e6d45e3e7 Sreekanth Reddy          2015-06-30  6142  		sas_device->connector_name[0] = '\0';
e6d45e3e7 Sreekanth Reddy          2015-06-30  6143  	}
758889564 Sreekanth Reddy          2017-10-10  6144  	/* get enclosure_logical_id & chassis_slot*/
758889564 Sreekanth Reddy          2017-10-10  6145  	sas_device->is_chassis_slot_valid = 0;
793a6223b Chaitra P B              2018-03-20  6146  	if (enclosure_dev) {
f92363d12 Sreekanth Reddy          2012-11-30  6147  		sas_device->enclosure_logical_id =
793a6223b Chaitra P B              2018-03-20  6148  		    le64_to_cpu(enclosure_dev->pg0.EnclosureLogicalID);
793a6223b Chaitra P B              2018-03-20  6149  		if (le16_to_cpu(enclosure_dev->pg0.Flags) &
758889564 Sreekanth Reddy          2017-10-10  6150  		    MPI2_SAS_ENCLS0_FLAGS_CHASSIS_SLOT_VALID) {
758889564 Sreekanth Reddy          2017-10-10  6151  			sas_device->is_chassis_slot_valid = 1;
758889564 Sreekanth Reddy          2017-10-10  6152  			sas_device->chassis_slot =
793a6223b Chaitra P B              2018-03-20  6153  					enclosure_dev->pg0.ChassisSlot;
758889564 Sreekanth Reddy          2017-10-10  6154  		}
758889564 Sreekanth Reddy          2017-10-10  6155  	}
758889564 Sreekanth Reddy          2017-10-10  6156  
f92363d12 Sreekanth Reddy          2012-11-30  6157  	/* get device name */
f92363d12 Sreekanth Reddy          2012-11-30  6158  	sas_device->device_name = le64_to_cpu(sas_device_pg0.DeviceName);
f92363d12 Sreekanth Reddy          2012-11-30  6159  
f92363d12 Sreekanth Reddy          2012-11-30  6160  	if (ioc->wait_for_discovery_to_complete)
f92363d12 Sreekanth Reddy          2012-11-30  6161  		_scsih_sas_device_init_add(ioc, sas_device);
f92363d12 Sreekanth Reddy          2012-11-30  6162  	else
f92363d12 Sreekanth Reddy          2012-11-30  6163  		_scsih_sas_device_add(ioc, sas_device);
f92363d12 Sreekanth Reddy          2012-11-30  6164  
d1cb5e495 Sreekanth Reddy          2015-11-11  6165  	sas_device_put(sas_device);
f92363d12 Sreekanth Reddy          2012-11-30  6166  	return 0;
f92363d12 Sreekanth Reddy          2012-11-30  6167  }
f92363d12 Sreekanth Reddy          2012-11-30  6168  

:::::: The code at line 6100 was first introduced by commit
:::::: 7588895646b5a943d3310271885c5935123a455c scsi: mpt3sas: Display chassis slot information of the drive

:::::: TO: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
:::::: CC: Martin K. Petersen <martin.petersen@oracle.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
