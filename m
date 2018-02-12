From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: UFS writing request failure handling
Date: Mon, 12 Feb 2018 12:21:22 +0000
Message-ID: <2a98182c0eed4f0d9615982dc3733024@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi, 
I am looking at UFS error handling, but I didn't notice re-issues requests with UTP error to the host controller.
According UFS host spec, "host software either completes the request that had the error and requests still outstanding 
with error to higher level software, or re-issues these requests to the host controller".
For the latest Linux UFS driver, it belongs to former one? 
If I am wrong, please correct me.
Thanks!
