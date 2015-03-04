From: Olaf Hering <olaf@aepfle.de>
Subject: noise in target_core_register_fabric
Date: Wed, 4 Mar 2015 16:46:20 +0100
Message-ID: <20150304154620.GA32023@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Is there a need to fill dmesg with noise like shown below whenever
targetcli-3.0 runs a command? I think the pr_err calls in those functions
should be converted to pr_debug.

Olaf

.....
[ 1240.045518] target_core_register_fabric() trying autoload for fc
[ 1240.045520] target_core_get_fabric() failed for fc
[ 1240.045926] target_core_register_fabric() trying autoload for usb_gadget
[ 1240.045928] target_core_get_fabric() failed for usb_gadget
[ 1240.046236] target_core_register_fabric() trying autoload for vhost
[ 1240.046238] target_core_get_fabric() failed for vhost
[ 1240.062569] target_core_register_fabric() trying autoload for srpt
[ 1240.062571] target_core_get_fabric() failed for srpt
[ 1240.069610] target_core_register_fabric() trying autoload for qla2xxx
[ 1240.069613] target_core_get_fabric() failed for qla2xxx
[ 1240.076049] target_core_register_fabric() trying autoload for fc
[ 1240.076051] target_core_get_fabric() failed for fc
[ 1240.076465] target_core_register_fabric() trying autoload for usb_gadget
[ 1240.076467] target_core_get_fabric() failed for usb_gadget
[ 1240.076770] target_core_register_fabric() trying autoload for vhost
[ 1240.076772] target_core_get_fabric() failed for vhost
[ 1240.088177] target_core_register_fabric() trying autoload for srpt
[ 1240.088179] target_core_get_fabric() failed for srpt
[ 1240.097338] target_core_register_fabric() trying autoload for qla2xxx
[ 1240.097340] target_core_get_fabric() failed for qla2xxx
[ 1240.104335] target_core_register_fabric() trying autoload for fc
[ 1240.104338] target_core_get_fabric() failed for fc
[ 1240.104801] target_core_register_fabric() trying autoload for usb_gadget
[ 1240.104803] target_core_get_fabric() failed for usb_gadget
[ 1240.105182] target_core_register_fabric() trying autoload for vhost
[ 1240.105184] target_core_get_fabric() failed for vhost
[ 1240.237564] target_core_register_fabric() trying autoload for srpt
[ 1240.237567] target_core_get_fabric() failed for srpt
[ 1240.246394] target_core_register_fabric() trying autoload for qla2xxx
[ 1240.246396] target_core_get_fabric() failed for qla2xxx
[ 1240.252862] target_core_register_fabric() trying autoload for fc
[ 1240.252864] target_core_get_fabric() failed for fc
[ 1240.253303] target_core_register_fabric() trying autoload for usb_gadget
[ 1240.253305] target_core_get_fabric() failed for usb_gadget
[ 1240.253597] target_core_register_fabric() trying autoload for vhost
[ 1240.253599] target_core_get_fabric() failed for vhost
[ 1240.270028] target_core_register_fabric() trying autoload for srpt
[ 1240.270030] target_core_get_fabric() failed for srpt
[ 1240.277044] target_core_register_fabric() trying autoload for qla2xxx
[ 1240.277046] target_core_get_fabric() failed for qla2xxx
[ 1240.283666] target_core_register_fabric() trying autoload for fc
[ 1240.283669] target_core_get_fabric() failed for fc
[ 1240.284102] target_core_register_fabric() trying autoload for usb_gadget
[ 1240.284104] target_core_get_fabric() failed for usb_gadget
....
