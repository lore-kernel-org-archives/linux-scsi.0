From: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: 2.6.39-rc5+ BUG at scsi_run_queue+0x24/0xe3
Date: Tue, 3 May 2011 12:52:32 -0600
Message-ID: <4DC04EF0.4020909@sandia.gov>
References: <4DC0330F.6050906@sandia.gov>
 <1304442019.10982.7.camel@mulgrave.site> <4DC03B0A.50209@sandia.gov>
 <1304444251.10982.9.camel@mulgrave.site> <4DC0415F.5020509@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DC0415F.5020509@sandia.gov>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi James,

FWIW, I noticed that commit 99f3c722e23 in scsi-rc-fixes-2.6
might want a Cc: stable@kernel.org, since the commit it's
fixing, 86cbfb5607d4, had one.

I'm not sure how that all works, but I thought I'd mention it
just in case.

-- Jim
