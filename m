From: James.Smart@Emulex.Com
Subject: RE: [PATCH] add transport class symlink to device object
Date: Sun, 14 Aug 2005 08:42:35 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD36@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63191 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932507AbVHNMnH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2005 08:43:07 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, greg@kroah.com
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org

I'll trust that James B's fix resolves things. Thought my testing was
straight-forward and ok. Guess not. Humbled again as a mere mortal in
the world of sysfs and transport/container logic... :)

Anyway, the last item that needs discussion is what name should the
symlink have ?

Here's a few points on why I chose a "class:<classname>" over 
"<classobjname>".

- Visually, I get more meaning out of seeing the class's name, than
  what is usually a redundant object name (many device and class
  objects have the same name).
- If a device could ever be associated with more than 1 class, it's
  supported (and no issues of name collision).
- The prefix of "class:" highlights what it is; makes it harder to lose
  in a long list of attributes; gives a simple handle for regex
  parsing (ex: "ls class*"); and helps avoid name collision with other
  attributes.
- The class object's name is always derivable from what the symlink
  points to.
- The class name is a good hint for utilities
(ok, last 2 are a little weak - you can parse the symlink for either of
 of them).

Preferences ?

-- james
