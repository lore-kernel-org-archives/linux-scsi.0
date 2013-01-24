From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: linux-3.7.4: BUG: unable to handle kernel NULL pointer
 dereference at target_fabric_port_link
Date: Thu, 24 Jan 2013 10:55:53 +0100
Message-ID: <1359021353.1325.1.camel@x61.thuisdomein>
References: <20130124.010724.710820132553071688.kou1.ono@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130124.010724.710820132553071688.kou1.ono@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kouichi ONO <kou1.ono@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-01-24 at 01:07 +0900, Kouichi ONO wrote:
> At target_fabric_port_link(), struct se_device *dev is used before set?

It seems the (stable specific) patch in
http://article.gmane.org/gmane.linux.kernel.stable/40880 should fix
that.


Paul Bolle
