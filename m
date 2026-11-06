Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964681;
	b=cYIiAt8qak7V1p5sSBgJB85wEWLjT6PTYljPpx6Cke5t5jOqeqdVJMjlTPLePwp8XBQC
	 QAey0iQOyvdMg7FvhOf+n22pjsdbkhcfR0HaLJiCZ5NMxd3hBzD3DIo9KXfkVNtVyxeXG
	 +cKFasfzymL2TRrBcKqNsTwaU24ANTzV/PC1hlIfn+5PGz0kBOlUy+laGoljVrO2LP2Vz
	 Qc5BCem4lmRsCBSbIGAFY/+cULRyL8G0MA3cFqkMU0JlnuA29QZKzSbYRyjCQnBkP7TUA
	 4fmAdo4xpMNdycbm91IwmLVhmIg3d0VyZTAAVQdGdHqwIKGVVTtTXf5t8aommuLFzig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964681;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=bIhVi7DqLa2KqhdxEJjUtsluGlm+9jNdA8ypyX5JrRg=;
	b=L4LHaeMTI1wCXQX0xRCGt5ukPsoWftxgBtgIyCjznaKtW9HTiKECAPpZkIJYNBLC55Cz
	 QI7ZXuzf7gwWXbuqbF17xVRAWeEgv3/r6uvVNVypN9LKZNcTrYRyVhba2JfCcRgNVi/Oj
	 YpwDzQyI3rvDwTx4AXmFXaFZ4XGU5l9vihP2bJ/akWAV8h6K4ly9ZOEyTisJIRTzPLkfF
	 0IEenCKYtjwD/Q57x8yA5pBXOEN/SO6/+UeePzBUubom8rYfERDe96hwdSIIiAMNb9e2E
	 l8h2hpGfj0IT5x+IP45K+EoM2+R7HJtNt7wCWmFSJDc7F9Akib3EpFZxzmvqDx3KXVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=A1s7jVa5;
	arc=none smtp.remote-ip=198.175.65.14
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B19606D817
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 11:31:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90B19606D817
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=A1s7jVa5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793964680; x=1825500680;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yjMSt5jgTuR/kLdo96ZTXNuUTiM+hXQL8bHFGBygnxg=;
  b=A1s7jVa5PXWo5wyVmQ2ALbFxypmUuduxsM+SqwQX1deOcBCAPHLIuBbY
   OOyiPllCcH8x+nmP/RcCyfjqTTfzV7qwTWrfoWaw0/VDA/fMKuArElKNQ
   W/2SemBGX0DdsUdBdbDkXJm7xaXvcUPpw945Mgd/oKlnO1YFYxBjMNdCO
   KKDBBP6KQblbdmhICYVo4b70QlJjH1AYMCqeQRpIEebnZoiGqNIX6USeH
   jrkIhBFHEAg2AVh2yaPYdeqj3nVqdHLSE75W6MCQuMfLaQfPAoj7Mmhhx
   HoFsTX+l/w7zLJXV3U/Iq+YXSgwlHXBRnmvVS5vULqRk/lXrCOTDficNw
   Q==;
X-CSE-ConnectionGUID: ox34QWwUQriR/0QV3LS+OQ==
X-CSE-MsgGUID: rDrI8+jFQS+N/OeMU5kC4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2669504"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2669504"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 03:31:20 -0800
X-CSE-ConnectionGUID: bgkCM0fZRwqbcApYRo4TUQ==
X-CSE-MsgGUID: Nj00MerhRPuZWjE0IX/TzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7577342"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 06 Nov 2026 03:31:18 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xPIA7-00000000p7z-1ojC;
	Fri, 06 Nov 2026 11:31:15 +0000
Date: Fri, 6 Nov 2026 19:30:48 +0800
From: kernel test robot <lkp@intel.com>
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com, chandrakanth.patil@broadcom.com,
	sweeti.vandure@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: Re: [PATCH 14/37] scsi: mpt3sas: Fix buffer overflow in
 _scsih_scsi_ioc_info
Message-ID: <202611061924.PaXwZZ0x-lkp@intel.com>
References: <1793925772-1303-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1793925772-1303-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>

Hi Shivasharan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v7.4-rc1 next-20261105]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shivasharan-S/scsi-mpt3sas-Validate-firmware-reported-IOCRequestFrameSize/20261105-164216
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/1793925772-1303-15-git-send-email-shivasharan.srikanteshwara%40broadcom.com
patch subject: [PATCH 14/37] scsi: mpt3sas: Fix buffer overflow in _scsih_scsi_ioc_info
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261106/202611061924.PaXwZZ0x-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261106/202611061924.PaXwZZ0x-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611061924.PaXwZZ0x-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/mpt3sas/mpt3sas_scsih.c: In function '_scsih_scsi_ioc_info':
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:5783:71: warning: '%s' directive output may be truncated writing up to 16 bytes into a region of size between 6 and 64 [-Wformat-truncation=]
    5783 |                 snprintf(desc_scsi_state, MPT_STRING_LENGTH, "%s%s%s%s%s",
         |                                                                       ^~
   drivers/scsi/mpt3sas/mpt3sas_scsih.c:5783:17: note: 'snprintf' output between 1 and 75 bytes into a destination of size 64
    5783 |                 snprintf(desc_scsi_state, MPT_STRING_LENGTH, "%s%s%s%s%s",
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    5784 |                          (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID) ?
         |                          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    5785 |                          "response info " : "",
         |                          ~~~~~~~~~~~~~~~~~~~~~~
    5786 |                          (scsi_state & MPI2_SCSI_STATE_TERMINATED) ?
         |                          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    5787 |                          "state terminated " : "",
         |                          ~~~~~~~~~~~~~~~~~~~~~~~~~
    5788 |                          (scsi_state & MPI2_SCSI_STATE_NO_SCSI_STATUS) ?
         |                          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    5789 |                          "no status " : "",
         |                          ~~~~~~~~~~~~~~~~~~
    5790 |                          (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_FAILED) ?
         |                          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    5791 |                          "autosense failed " : "",
         |                          ~~~~~~~~~~~~~~~~~~~~~~~~~
    5792 |                          (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID) ?
         |                          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    5793 |                          "autosense valid " : "");
         |                          ~~~~~~~~~~~~~~~~~~~~~~~~


vim +5783 drivers/scsi/mpt3sas/mpt3sas_scsih.c

  5639	
  5640	/**
  5641	 * _scsih_scsi_ioc_info - translated non-successful SCSI_IO request
  5642	 * @ioc: per adapter object
  5643	 * @scmd: pointer to scsi command object
  5644	 * @mpi_reply: reply mf payload returned from firmware
  5645	 * @smid: ?
  5646	 *
  5647	 * scsi_status - SCSI Status code returned from target device
  5648	 * scsi_state - state info associated with SCSI_IO determined by ioc
  5649	 * ioc_status - ioc supplied status info
  5650	 */
  5651	static void
  5652	_scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
  5653		Mpi2SCSIIOReply_t *mpi_reply, u16 smid)
  5654	{
  5655		u32 response_info;
  5656		u8 *response_bytes;
  5657		u16 ioc_status = le16_to_cpu(mpi_reply->IOCStatus) &
  5658		    MPI2_IOCSTATUS_MASK;
  5659		u8 scsi_state = mpi_reply->SCSIState;
  5660		u8 scsi_status = mpi_reply->SCSIStatus;
  5661		char *desc_ioc_state = NULL;
  5662		char *desc_scsi_status = NULL;
  5663		char *desc_scsi_state = ioc->tmp_string;
  5664		u32 log_info = le32_to_cpu(mpi_reply->IOCLogInfo);
  5665		struct _sas_device *sas_device = NULL;
  5666		struct _pcie_device *pcie_device = NULL;
  5667		struct scsi_target *starget = scmd->device->sdev_target;
  5668		struct MPT3SAS_TARGET *priv_target = starget->hostdata;
  5669		char *device_str = NULL;
  5670	
  5671		if (!priv_target)
  5672			return;
  5673		if (ioc->hide_ir_msg)
  5674			device_str = "WarpDrive";
  5675		else
  5676			device_str = "volume";
  5677	
  5678		if (log_info == 0x31170000)
  5679			return;
  5680	
  5681		switch (ioc_status) {
  5682		case MPI2_IOCSTATUS_SUCCESS:
  5683			desc_ioc_state = "success";
  5684			break;
  5685		case MPI2_IOCSTATUS_INVALID_FUNCTION:
  5686			desc_ioc_state = "invalid function";
  5687			break;
  5688		case MPI2_IOCSTATUS_SCSI_RECOVERED_ERROR:
  5689			desc_ioc_state = "scsi recovered error";
  5690			break;
  5691		case MPI2_IOCSTATUS_SCSI_INVALID_DEVHANDLE:
  5692			desc_ioc_state = "scsi invalid dev handle";
  5693			break;
  5694		case MPI2_IOCSTATUS_SCSI_DEVICE_NOT_THERE:
  5695			desc_ioc_state = "scsi device not there";
  5696			break;
  5697		case MPI2_IOCSTATUS_SCSI_DATA_OVERRUN:
  5698			desc_ioc_state = "scsi data overrun";
  5699			break;
  5700		case MPI2_IOCSTATUS_SCSI_DATA_UNDERRUN:
  5701			desc_ioc_state = "scsi data underrun";
  5702			break;
  5703		case MPI2_IOCSTATUS_SCSI_IO_DATA_ERROR:
  5704			desc_ioc_state = "scsi io data error";
  5705			break;
  5706		case MPI2_IOCSTATUS_SCSI_PROTOCOL_ERROR:
  5707			desc_ioc_state = "scsi protocol error";
  5708			break;
  5709		case MPI2_IOCSTATUS_SCSI_TASK_TERMINATED:
  5710			desc_ioc_state = "scsi task terminated";
  5711			break;
  5712		case MPI2_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:
  5713			desc_ioc_state = "scsi residual mismatch";
  5714			break;
  5715		case MPI2_IOCSTATUS_SCSI_TASK_MGMT_FAILED:
  5716			desc_ioc_state = "scsi task mgmt failed";
  5717			break;
  5718		case MPI2_IOCSTATUS_SCSI_IOC_TERMINATED:
  5719			desc_ioc_state = "scsi ioc terminated";
  5720			break;
  5721		case MPI2_IOCSTATUS_SCSI_EXT_TERMINATED:
  5722			desc_ioc_state = "scsi ext terminated";
  5723			break;
  5724		case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
  5725			desc_ioc_state = "eedp guard error";
  5726			break;
  5727		case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
  5728			desc_ioc_state = "eedp ref tag error";
  5729			break;
  5730		case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
  5731			desc_ioc_state = "eedp app tag error";
  5732			break;
  5733		case MPI2_IOCSTATUS_INSUFFICIENT_POWER:
  5734			desc_ioc_state = "insufficient power";
  5735			break;
  5736		default:
  5737			desc_ioc_state = "unknown";
  5738			break;
  5739		}
  5740	
  5741		switch (scsi_status) {
  5742		case MPI2_SCSI_STATUS_GOOD:
  5743			desc_scsi_status = "good";
  5744			break;
  5745		case MPI2_SCSI_STATUS_CHECK_CONDITION:
  5746			desc_scsi_status = "check condition";
  5747			break;
  5748		case MPI2_SCSI_STATUS_CONDITION_MET:
  5749			desc_scsi_status = "condition met";
  5750			break;
  5751		case MPI2_SCSI_STATUS_BUSY:
  5752			desc_scsi_status = "busy";
  5753			break;
  5754		case MPI2_SCSI_STATUS_INTERMEDIATE:
  5755			desc_scsi_status = "intermediate";
  5756			break;
  5757		case MPI2_SCSI_STATUS_INTERMEDIATE_CONDMET:
  5758			desc_scsi_status = "intermediate condmet";
  5759			break;
  5760		case MPI2_SCSI_STATUS_RESERVATION_CONFLICT:
  5761			desc_scsi_status = "reservation conflict";
  5762			break;
  5763		case MPI2_SCSI_STATUS_COMMAND_TERMINATED:
  5764			desc_scsi_status = "command terminated";
  5765			break;
  5766		case MPI2_SCSI_STATUS_TASK_SET_FULL:
  5767			desc_scsi_status = "task set full";
  5768			break;
  5769		case MPI2_SCSI_STATUS_ACA_ACTIVE:
  5770			desc_scsi_status = "aca active";
  5771			break;
  5772		case MPI2_SCSI_STATUS_TASK_ABORTED:
  5773			desc_scsi_status = "task aborted";
  5774			break;
  5775		default:
  5776			desc_scsi_status = "unknown";
  5777			break;
  5778		}
  5779	
  5780		if (!scsi_state)
  5781			desc_scsi_state = " ";
  5782		else
> 5783			snprintf(desc_scsi_state, MPT_STRING_LENGTH, "%s%s%s%s%s",
  5784				 (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID) ?
  5785				 "response info " : "",
  5786				 (scsi_state & MPI2_SCSI_STATE_TERMINATED) ?
  5787				 "state terminated " : "",
  5788				 (scsi_state & MPI2_SCSI_STATE_NO_SCSI_STATUS) ?
  5789				 "no status " : "",
  5790				 (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_FAILED) ?
  5791				 "autosense failed " : "",
  5792				 (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID) ?
  5793				 "autosense valid " : "");
  5794	
  5795		scsi_print_command(scmd);
  5796	
  5797		if (priv_target->flags & MPT_TARGET_FLAGS_VOLUME) {
  5798			ioc_warn(ioc, "\t%s wwid(0x%016llx)\n",
  5799				 device_str, (u64)priv_target->sas_address);
  5800		} else if (priv_target->flags & MPT_TARGET_FLAGS_PCIE_DEVICE) {
  5801			pcie_device = mpt3sas_get_pdev_from_target(ioc, priv_target);
  5802			if (pcie_device) {
  5803				ioc_info(ioc, "\twwid(0x%016llx), port(%d)\n",
  5804					 (u64)pcie_device->wwid, pcie_device->port_num);
  5805				if (pcie_device->enclosure_handle != 0)
  5806					ioc_info(ioc, "\tenclosure logical id(0x%016llx), slot(%d)\n",
  5807						 (u64)pcie_device->enclosure_logical_id,
  5808						 pcie_device->slot);
  5809				if (pcie_device->connector_name[0])
  5810					ioc_info(ioc, "\tenclosure level(0x%04x), connector name( %s)\n",
  5811						 pcie_device->enclosure_level,
  5812						 pcie_device->connector_name);
  5813				pcie_device_put(pcie_device);
  5814			}
  5815		} else {
  5816			sas_device = mpt3sas_get_sdev_from_target(ioc, priv_target);
  5817			if (sas_device) {
  5818				ioc_warn(ioc, "\tsas_address(0x%016llx), phy(%d)\n",
  5819					 (u64)sas_device->sas_address, sas_device->phy);
  5820	
  5821				_scsih_display_enclosure_chassis_info(ioc, sas_device,
  5822				    NULL, NULL);
  5823	
  5824				sas_device_put(sas_device);
  5825			}
  5826		}
  5827	
  5828		ioc_warn(ioc, "\thandle(0x%04x), ioc_status(%s)(0x%04x), smid(%d)\n",
  5829			 le16_to_cpu(mpi_reply->DevHandle),
  5830			 desc_ioc_state, ioc_status, smid);
  5831		ioc_warn(ioc, "\trequest_len(%d), underflow(%d), resid(%d)\n",
  5832			 scsi_bufflen(scmd), scmd->underflow, scsi_get_resid(scmd));
  5833		ioc_warn(ioc, "\ttag(%d), transfer_count(%d), sc->result(0x%08x)\n",
  5834			 le16_to_cpu(mpi_reply->TaskTag),
  5835			 le32_to_cpu(mpi_reply->TransferCount), scmd->result);
  5836		ioc_warn(ioc, "\tscsi_status(%s)(0x%02x), scsi_state(%s)(0x%02x)\n",
  5837			 desc_scsi_status, scsi_status, desc_scsi_state, scsi_state);
  5838	
  5839		if (scsi_state & MPI2_SCSI_STATE_AUTOSENSE_VALID) {
  5840			struct sense_info data;
  5841			_scsih_normalize_sense(scmd->sense_buffer, &data);
  5842			ioc_warn(ioc, "\t[sense_key,asc,ascq]: [0x%02x,0x%02x,0x%02x], count(%d)\n",
  5843				 data.skey, data.asc, data.ascq,
  5844				 le32_to_cpu(mpi_reply->SenseCount));
  5845		}
  5846		if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID) {
  5847			response_info = le32_to_cpu(mpi_reply->ResponseInfo);
  5848			response_bytes = (u8 *)&response_info;
  5849			_scsih_response_code(ioc, response_bytes[0]);
  5850		}
  5851	}
  5852	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
